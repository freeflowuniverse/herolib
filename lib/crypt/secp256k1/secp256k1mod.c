#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>
#include <sys/random.h>
#include <stddef.h>
#include <limits.h>
#include <stdio.h>
#include "secp256k1mod.h"

static int fill_random(unsigned char* data, size_t size) {
#if defined(__linux__) || defined(__FreeBSD__)
    ssize_t res = getrandom(data, size, 0);
    if(res < 0 || (size_t) res != size) {
        return 0;
    } else {
        return 1;
    }

#elif defined(__APPLE__) || defined(__OpenBSD__)
    int res = getentropy(data, size);
    if(res == 0) {
        return 1;
    } else {
        return 0;
    }
#endif

    return 0;
}

static void dumphex(unsigned char *data, size_t size) {
    size_t i;

    printf("0x");

    for(i = 0; i < size; i++) {
        printf("%02x", data[i]);
    }

    printf("\n");
}

static char *hexifier(unsigned char *data, size_t size) {
    char *target = calloc(sizeof(char), (size * 2) + 4);
    char buffer[8];

    strcpy(target, "0x");
    memset(buffer, 0, sizeof(buffer));

    for(size_t i = 0; i < size; i++) {
        sprintf(buffer, "%02x", data[i]);
        strcat(target, buffer);
    }

    return target;
}

static unsigned char *hexparse(char *input) {
    if(strncmp(input, "0x", 2) != 0)
        return NULL;

    size_t length = strlen(input);

    unsigned char *target = calloc(sizeof(char), length);
    char *pos = input + 2;

    for(size_t count = 0; count < length - 2; count++) {
        sscanf(pos, "%2hhx", &target[count]);
        pos += 2;
    }

    return target;
}

static void secp256k1_erase(unsigned char *target, size_t length) {
#if defined(__GNUC__)
    // memory barrier to avoid memset optimization
    memset(target, 0, length);
    __asm__ __volatile__("" : : "r"(target) : "memory");
#else
    // if we can't, fill with random, still better than
    // risking avoid memset
    fill_random(target, length);
#endif
}

static void secp256k1_erase_free(unsigned char *target, size_t length) {
    secp256k1_erase(target, length);
    free(target);
}

secp256k1_t *secp256k1_new() {
    secp256k1_t *secp = malloc(sizeof(secp256k1_t));
    unsigned char randomize[32];

    secp->kntxt = secp256k1_context_create(SECP256K1_CONTEXT_NONE);

    if(!fill_random(randomize, sizeof(randomize))) {
        printf("[-] failed to generate randomness\n");
        return NULL;
    }

    // side-channel protection
    int val = secp256k1_context_randomize(secp->kntxt, randomize);
    assert(val);

    // allocate keys and initialize them empty
    secp->seckey = calloc(sizeof(char), SECKEY_SIZE);
    secp->compressed = calloc(sizeof(char), COMPPUB_SIZE);
    secp->xcompressed = calloc(sizeof(char), XSERPUB_SIZE);

    return secp;
}

void secp256k1_free(secp256k1_t *secp) {
    secp256k1_context_destroy(secp->kntxt);
    secp256k1_erase_free(secp->seckey, SECKEY_SIZE);
    secp256k1_erase_free(secp->compressed, COMPPUB_SIZE);
    secp256k1_erase_free(secp->xcompressed, XSERPUB_SIZE);
    free(secp);
}

static int secp256k1_populate_public_key(secp256k1_t *secp) {
    int retval;

    retval = secp256k1_xonly_pubkey_from_pubkey(secp->kntxt, &secp->xpubkey, NULL, &secp->pubkey);
    assert(retval);

    retval = secp256k1_xonly_pubkey_serialize(secp->kntxt, secp->xcompressed, &secp->xpubkey);
    assert(retval);

    return 0;
}

static int secp256k1_populate_key(secp256k1_t *secp) {
    int retval;

    retval = secp256k1_ec_pubkey_create(secp->kntxt, &secp->pubkey, secp->seckey);
    assert(retval);

    size_t len = COMPPUB_SIZE;
    retval = secp256k1_ec_pubkey_serialize(secp->kntxt, secp->compressed, &len, &secp->pubkey, SECP256K1_EC_COMPRESSED);
    assert(retval);

    // always compute the xonly pubkey as well, so we don't need to compute
    // it later for schnorr
    retval = secp256k1_keypair_create(secp->kntxt, &secp->keypair, secp->seckey);
    assert(retval);

    return secp256k1_populate_public_key(secp);
}

int secp256k1_generate_key(secp256k1_t *secp) {
    while(1) {
        if(!fill_random(secp->seckey, SECKEY_SIZE)) {
            printf("[-] failed to generate randomness\n");
            return 1;
        }

        if(secp256k1_ec_seckey_verify(secp->kntxt, secp->seckey) == 0) {
            // try again
            continue;
        }

        return secp256k1_populate_key(secp);
    }

    return 1;
}

// backward compatibility
int secp256k1_load_key(secp256k1_t *secp, char *key) {
    // only allow valid key size
    if(strlen(key) != (SECKEY_SIZE * 2) + 2)
        return 1;

    unsigned char *binkey = hexparse(key);

    free(secp->seckey);
    secp->seckey = binkey;

    if(secp256k1_ec_seckey_verify(secp->kntxt, secp->seckey) == 0) {
        // invalid key
        return 1;
    }

    return secp256k1_populate_key(secp);
}

int secp256k1_load_private_key(secp256k1_t *secp, char *key) {
    return secp256k1_load_key(secp, key);
}

int secp256k1_load_public_key(secp256k1_t *secp, char *key) {
    // only allow valid key size
    if(strlen(key) != (COMPPUB_SIZE * 2) + 2)
        return 1;

    unsigned char *binkey = hexparse(key);

    free(secp->compressed);
    secp->compressed = binkey;

    if(!secp256k1_ec_pubkey_parse(secp->kntxt, &secp->pubkey, secp->compressed, COMPPUB_SIZE)) {
        printf("[-] failed to load public key\n");
        return 1;
    }

    return secp256k1_populate_public_key(secp);;
}


unsigned char *secp265k1_shared_key(secp256k1_t *private, secp256k1_t *public) {
    unsigned char *shared = malloc(sizeof(unsigned char) * SHARED_SIZE);

    int val = secp256k1_ecdh(private->kntxt, shared, &public->pubkey, private->seckey, NULL, NULL);
    assert(val);

    return shared;
}

unsigned char *secp256k1_sign_hash(secp256k1_t *secp, unsigned char *hash, size_t length) {
    secp256k1_sign_t signature;
    int retval;

    if(length != SHA256_SIZE) {
        printf("[-] warning: you should only sign sha-256 hash, size mismatch\n");
        printf("[-] warning: you get warned\n");
    }

    retval = secp256k1_ecdsa_sign(secp->kntxt, &signature.sig, hash, secp->seckey, NULL, NULL);
    assert(retval);

    signature.serialized = malloc(sizeof(unsigned char) * SERSIG_SIZE);

    retval = secp256k1_ecdsa_signature_serialize_compact(secp->kntxt, signature.serialized, &signature.sig);
    assert(retval);

    return signature.serialized;
}

secp256k1_sign_t *secp256k1_load_signature(secp256k1_t *secp, unsigned char *serialized, size_t length) {
    secp256k1_sign_t *signature;

    if(length != SERSIG_SIZE) {
        printf("[-] serialized signature length mismatch, expected %u bytes\n", SERSIG_SIZE);
        return NULL;
    }

    signature = calloc(sizeof(secp256k1_sign_t), 1);

    signature->length = length;
    signature->serialized = malloc(length);
    memcpy(signature->serialized, serialized, length);

    if(!secp256k1_ecdsa_signature_parse_compact(secp->kntxt, &signature->sig, signature->serialized)) {
        printf("[-] failed to parse the signature\n");
        // FIXME: cleanup
        return NULL;
    }

    return signature;
}

void secp256k1_sign_free(secp256k1_sign_t *signature) {
    secp256k1_erase_free(signature->serialized, signature->length);
    free(signature);
}

int secp256k1_sign_verify(secp256k1_t *secp, secp256k1_sign_t *signature, unsigned char *hash, size_t length) {
    if(length != SHA256_SIZE) {
        printf("[-] warning: you should only check sha-256 hash, size mismatch\n");
    }

    return secp256k1_ecdsa_verify(secp->kntxt, &signature->sig, hash, &secp->pubkey);
}

unsigned char *secp256k1_schnorr_sign_hash(secp256k1_t *secp, unsigned char *hash, size_t length) {
    unsigned char aux[32];
    unsigned char *signature;
    int retval;

    if(length != SHA256_SIZE) {
        printf("[-] warning: you should only sign sha-256 hash, size mismatch\n");
        printf("[-] warning: you get warned\n");
    }

    if(!fill_random(aux, sizeof(aux))) {
        printf("[-] failed to generate randomness\n");
        return NULL;
    }

    signature = malloc(sizeof(unsigned char) * SCHSIG_SIZE);

    retval = secp256k1_schnorrsig_sign32(secp->kntxt, signature, hash, &secp->keypair, aux);
    assert(retval);

    return signature;
}

int secp256k1_schnorr_verify(secp256k1_t *secp, unsigned char *signature, size_t siglen, unsigned char *hash, size_t hashlen) {
    if(hashlen != SHA256_SIZE) {
        printf("[-] warning: you should only check sha-256 hash, size mismatch\n");
    }

    if(siglen != SCHSIG_SIZE) {
        printf("[-] invalid signature length, should be %u bytes\n", SCHSIG_SIZE);
        return 2;
    }

    return secp256k1_schnorrsig_verify(secp->kntxt, signature, hash, hashlen, &secp->xpubkey);
}

void secp256k1_dumps(secp256k1_t *secp) {
    printf("Private Key: ");
    dumphex(secp->seckey, SECKEY_SIZE);

    printf("Public Key : ");
    dumphex(secp->compressed, COMPPUB_SIZE);

    printf("X-Only Key : ");
    dumphex(secp->xcompressed, XSERPUB_SIZE);
}

// backward compatibility
char *secp256k1_export(secp256k1_t *secp) {
    return hexifier(secp->seckey, SECKEY_SIZE);
}

// return private key in hex format
char *secp256k1_private_key(secp256k1_t *secp) {
    return secp256k1_export(secp);
}

char *secp256k1_public_key(secp256k1_t *secp) {
    return hexifier(secp->compressed, COMPPUB_SIZE);
}


#ifndef NO_SECP_MAIN
int main() {
    secp256k1_t *wendy = secp256k1_new();
    secp256k1_generate_key(wendy);

    printf("Wendy:\n");
    dumphex(wendy->seckey, SECKEY_SIZE);
    dumphex(wendy->compressed, COMPPUB_SIZE);
    dumphex(wendy->xcompressed, XSERPUB_SIZE);

    // bob
    secp256k1_t *bob = secp256k1_new();
    secp256k1_load_key(bob, "0x478b45390befc3097e3e6e1a74d78a34a113f4b9ab17deb87e9b48f43893af83");

    printf("\n");
    printf("Bob:\n");
    dumphex(bob->seckey, SECKEY_SIZE);
    dumphex(bob->compressed, COMPPUB_SIZE);
    dumphex(bob->xcompressed, XSERPUB_SIZE);

    // export functions
    char *priv = secp256k1_private_key(bob);
    char *pubk = secp256k1_public_key(bob);
    printf("Private export: %s\n", priv);
    printf("Public  export: %s\n", pubk);
    free(priv);

    secp256k1_t *bobpub = secp256k1_new();
    int val = secp256k1_load_public_key(bobpub, "0x03310ec949bd4f7fc24f823add1394c78e1e9d70949ccacf094c027faa20d99e21");
    printf("Public key loader: %d\n", val);
    secp256k1_dumps(bobpub);

    // alice
    secp256k1_t *alice = secp256k1_new();
    secp256k1_load_key(alice, "0x8225825815f42e1c24a2e98714d99fee1a20b5ac864fbcb7a103cd0f37f0ffec");

    printf("\n");
    printf("Alice:\n");
    dumphex(alice->seckey, SECKEY_SIZE);
    dumphex(alice->compressed, COMPPUB_SIZE);
    dumphex(alice->xcompressed, XSERPUB_SIZE);

    unsigned char *shared1 = secp265k1_shared_key(bob, alice);
    unsigned char *shared2 = secp265k1_shared_key(alice, bob);

    printf("\n");
    printf("Shared Key:\n");
    dumphex(shared1, SHARED_SIZE);
    dumphex(shared2, SHARED_SIZE);

    secp256k1_erase_free(shared1, SHARED_SIZE);
    secp256k1_erase_free(shared2, SHARED_SIZE);

    // Hello, world!
    unsigned char hash[32] = {
        0x31, 0x5F, 0x5B, 0xDB, 0x76, 0xD0, 0x78, 0xC4,
        0x3B, 0x8A, 0xC0, 0x06, 0x4E, 0x4A, 0x01, 0x64,
        0x61, 0x2B, 0x1F, 0xCE, 0x77, 0xC8, 0x69, 0x34,
        0x5B, 0xFC, 0x94, 0xC7, 0x58, 0x94, 0xED, 0xD3,
    };

    unsigned char *sign = secp256k1_sign_hash(bob, hash, sizeof(hash));

    printf("\n");
    printf("Signature (ecdsa):\n");
    dumphex(sign, SERSIG_SIZE);

    secp256k1_sign_t *sigobj = secp256k1_load_signature(bob, sign, SERSIG_SIZE);
    int valid = secp256k1_sign_verify(bob, sigobj, hash, sizeof(hash));

    printf("\n");
    printf("Signature valid: %d\n", valid);

    secp256k1_sign_free(sigobj);

    // using bobpub
    sigobj = secp256k1_load_signature(bobpub, sign, SERSIG_SIZE);
    valid = secp256k1_sign_verify(bobpub, sigobj, hash, sizeof(hash));

    printf("\n");
    printf("Signature valid (using bob public key only): %d\n", valid);

    secp256k1_erase_free(sign, SERSIG_SIZE);
    secp256k1_sign_free(sigobj);

    sign = secp256k1_schnorr_sign_hash(bob, hash, sizeof(hash));

    printf("\n");
    printf("Signature (schnorr):\n");
    dumphex(sign, SCHSIG_SIZE);

    valid = secp256k1_schnorr_verify(bob, sign, SCHSIG_SIZE, hash, sizeof(hash));

    printf("\n");
    printf("Signature valid: %d\n", valid);

    valid = secp256k1_schnorr_verify(bobpub, sign, SCHSIG_SIZE, hash, sizeof(hash));

    printf("\n");
    printf("Signature valid (using bob pubkey key only): %d\n", valid);

    secp256k1_erase_free(sign, SCHSIG_SIZE);

    printf("\n");
    printf("Wendy Export:\n");
    char *export = secp256k1_export(wendy);
    printf(">> %s\n", export);
    free(export);

    printf("\n");
    printf("Wendy Keys dump:\n");
    secp256k1_dumps(wendy);

    secp256k1_free(bob);
    secp256k1_free(alice);
    secp256k1_free(wendy);

    return 0;
}
#endif

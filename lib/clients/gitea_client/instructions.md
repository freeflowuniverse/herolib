
example how to 

```v
pub fn (mut self GiteaClient) list_classifiers() ![]Classifier {
	req := httpconnection.Request{
		method: .get
		prefix: 'v1/classifiers'
	}
    //fetch the http client
	mut httpclient := self.httpclient()!
	response := httpclient.get(req)!
	classifiers := json.decode([]Classifier, response)!
	return classifiers
}

```
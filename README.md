# Testing the lacedeamon API
The api can be found at `http://lacedeamon.spartaglobal.com/todos`

## Specification
**Check the follwing:**
- http request rspec
- response code
- response message
- valid date

### Get Request
- get all
- get specific todo (DONE)

### Post Request
- post to collection (DONE)
- post to todo item should be error 405

### Patch Requests
- patch collection should be error 405
- patch item

### Puts Requests
- put collection should be error 405
- put to todo item

### Delete Requests
- delete collection should be error 405 (DONE)
- delete item

### Validation
- Post with invalid date 

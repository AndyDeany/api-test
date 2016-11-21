require 'httparty'

url = 'http://lacedeamon.spartaglobal.com/todos'

title = 'title=Remember%20the%20milk'
new_title = 'title=Get%20some%20bread%20instead'

due = 'due=31-07-2017'
new_due = 'due=15-01-1999'

describe HTTParty do
  it 'should allow us to POST, GET and DELETE todos' do
    post = HTTParty.post(
      "#{url}?"\
      "#{title}&"\
      "#{due}"
    )
    expect(post.code).to eq 201
    expect(post.message).to eq 'Created'
    id = post['id']

    get = HTTParty.get("#{url}/#{id}")
    expect(get.code).to eq 200
    expect(get.message).to eq 'OK'
    expect(get['title']).to eq 'Remember the milk'
    expect(get['due']).to eq '2017-07-31'

    delete = HTTParty.delete("#{url}/#{id}")
    expect(delete.code).to eq 204
    expect(delete.message).to eq 'No Content'
  end

  it 'should not allow us to post with an invalid date' do
    post = HTTParty.post(
      "#{url}?"\
      "#{title}&"\
      "due=invalid_date"
    )
    expect(post.code).to eq 422
    expect(post.message).to eq 'Unprocessable Entity'
  end

  it 'should not allow us to post to a specific todo' do
    id = HTTParty.post(
      "#{url}?"\
      "#{title}&"\
      "#{due}"
    )['id']
    post = HTTParty.post(
      "#{url}/#{id}?"\
      "#{title}&"\
      "#{due}"
    )
    expect(post.code).to eq 405
    expect(post.message).to eq 'Method Not Allowed'
  end

  it 'should allow us to get the todos collection' do
    id = HTTParty.post(
      "#{url}?"\
      "#{title}&"\
      "#{due}"
    )['id']
    get = HTTParty.get(url)
    expect(get.code).to eq 200
    expect(get.message).to eq 'OK'
    expect(get).to include(
      'id' => id, 'title' => 'Remember the milk'
    )
    HTTParty.delete("#{url}/#{id}")
  end

  it 'should not allow us to delete the todos collection' do#
    delete = HTTParty.delete(url)
    expect(delete.code).to eq 405
    expect(delete.message).to eq 'Method Not Allowed'
  end

  it 'should allow us to send a PATCH request to a specific todo' do
    id = HTTParty.post(
      "#{url}?"\
      "#{title}&"\
      "#{due}"
    )['id']
    patch = HTTParty.patch(
      "#{url}/#{id}?"\
      "#{new_title}"
    )
    expect(patch.code).to eq 200
    expect(patch.message).to eq 'OK'
    expect(patch['title']).to eq 'Get some bread instead'
  end

  it 'should not allow us to patch the todos collections' do
    patch = HTTParty.patch(url)
    expect(patch.code).to eq 405
    expect(patch.message).to eq 'Method Not Allowed'
  end

  it 'should allow us to send a PUT request to a specific todo' do
    id = HTTParty.post(
      "#{url}?"\
      "#{title}&"\
      "#{due}"
    )['id']
    put = HTTParty.patch(
      "#{url}/#{id}?"\
      "#{new_title}&"\
      "#{new_due}"
    )
    expect(put.code).to eq 200
    expect(put.message).to eq 'OK'
    get = HTTParty.get("#{url}/#{id}")
    expect(get['title']).to eq 'Get some bread instead'
    expect(get['due']).to eq '1999-01-15'
  end

  it 'should not allow us to send a PUT request to the todos collection' do
    put = HTTParty.put(url)
    expect(put.code).to eq 405
    expect(put.message).to eq 'Method Not Allowed'
  end
end

from firebase import firebase

SECRET = '4mrNqcCBPeSV0KmAB8gSKlyYw3BczRU4AYoysl0N'
firebase1 = firebase.FirebaseApplication('https://easternt-3a493.firebaseio.com', authentication=None)

authentication = firebase.FirebaseAuthentication(SECRET, 'vbigyi@gmail.com', extra={'id': 123})

firebase1.authentication = authentication
print authentication.extra

user = authentication.get_user()
print user.firebase_auth_token

result = firebase1.get('/user', None)

result_post = firebase1.post()
print(result)
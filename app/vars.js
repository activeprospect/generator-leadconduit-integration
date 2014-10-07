var faker = require('faker');

module.exports = function(fields) {
  var vars = {};
  return fields.reduce(function(vars, field) {
    var id = field.id;
    switch (id) {
      case 'first_name':
        vars[id] = faker.name.firstName();
        break;
      case 'last_name':
        vars[id] = faker.name.firstName();
        break;
      case 'email':
        vars[id] = faker.internet.email(vars.first_name, vars.last_name);
        break;
      case 'phone_1':
      case 'phone_2':
      case 'phone_3':
        vars[id] = faker.phone.phoneNumber();
        break;
      case 'address_1':
        vars[id] = faker.address.streetAddress();
        break;
      case 'address_2':
        vars[id] = faker.address.secondaryAddress();
        break;
      case 'city':
        vars[id] = faker.address.city();
        break;
      case 'state':
        vars[id] = faker.address.stateAbbr();
        break;
      case 'postal_code':
        vars[id] = faker.address.zipCode();
        break;
      case 'comments':
        vars[id] = faker.lorem.sentence();
        break;
    }
    return vars;
  }, vars);
};
Joi = require 'joi'
module.exports =
  login:
    payload:
      email: Joi.string().email().required().max(254)
      password: Joi.string().regex(/^[a-zA-Z0-9]{3,30}$/).min(6).max(100).required()
      name: Joi.string().alphanum().min(3).max(30).required()

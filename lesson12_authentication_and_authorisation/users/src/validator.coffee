Joi = require 'joi'
module.exports =
  register:
    payload:
      email: Joi.string().email().max(254).required()
      password: Joi.string().regex(/^[a-za-z0-9]{3,30}$/).min(6).max(100).required()
      name: Joi.string().alphanum().min(3).max(30).required()

  login:
    payload:
      email: Joi.string().email().max(254).required()
      password: Joi.string().regex(/^[a-za-z0-9]{3,30}$/).min(6).max(100).required()

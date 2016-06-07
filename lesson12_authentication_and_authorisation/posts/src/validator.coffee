Joi = require 'joi'
module.exports =
  create:
    payload:
      name: Joi.string().required()
      user_key: Joi.string().required()

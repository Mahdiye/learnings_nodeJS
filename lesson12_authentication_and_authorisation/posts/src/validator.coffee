Joi = require 'joi'
module.exports =
  create:
    payload:
      name: Joi.string().required()
      user_key: Joi.string().required()

  get_by_key:
    params:
      post_key: Joi.string().required()

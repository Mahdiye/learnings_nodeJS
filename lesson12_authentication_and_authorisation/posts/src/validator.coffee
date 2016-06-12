Joi = require 'joi'
module.exports =
  create:
    payload:
      name: Joi.string().required()
      user_key: Joi.string().required()

  get_by_key:
    params:
      post_key: Joi.string().required()

  list:
    query:
      page: Joi.number()

  list_my_post:
    query:
      page: Joi.number()

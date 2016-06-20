Joi = require 'joi'
module.exports =
  create:
    payload:
      name: Joi.string().required()

  get_by_key:
    params:
      post_key: Joi.string().required()

  list:
    query:
      page: Joi.number()

  list_my_post:
    query:
      page: Joi.number()

  delete:
    params:
      key: Joi.string().required()

  update:
    params:
      key: Joi.string().required()
    payload:
      name: Joi.string()
      user_key: Joi.string()

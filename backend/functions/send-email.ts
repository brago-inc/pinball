import { Handler } from '@netlify/functions'
import * as httpStatus from 'http-status'
import { MongoClient, MongoServerError } from 'mongodb'


// @ts-ignore
const client = new MongoClient(process.env.MONGODB_URI)
const clientPromise = client.connect()

const handler: Handler = async (event, context) => {
  try {
    const database = (await clientPromise).db(process.env.MONGODB_DATABASE)
    // @ts-ignore
    const collection = database.collection(process.env.MONGODB_MAIL_CODE_COLLECTION)

    const email = event.queryStringParameters?.email
    if (!email) {
      return { statusCode: httpStatus.BAD_REQUEST, body: 'invalid params' }
    }

    // 1、校验邮箱格式


    // 2、生成四位随机数
    const randomCode = 4023

    // 3、将验证码插入到数据库中
    await collection.insertOne({ email, code: randomCode, createTime: Date.now(), updateTime: Date.now() })

    // 4、发送邮件


    return {
      statusCode: httpStatus.OK,
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Headers': 'Content-Type',
        'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE'
      },
    }
  } catch (error) {
    if (error instanceof MongoServerError) {
      return { statusCode: httpStatus.INTERNAL_SERVER_ERROR, body: error }
    }
    return { statusCode: httpStatus.INTERNAL_SERVER_ERROR, body: (error as any).message }
  }
}

export { handler }

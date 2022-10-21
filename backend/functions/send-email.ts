import { Handler } from '@netlify/functions'
import * as httpStatus from 'http-status'
import { MongoClient, MongoServerError } from 'mongodb'
import { headers } from "../utils/constants"
import { validateEmail, sendEmail } from '../utils/email'
import { random } from '../utils/random'

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
      return { statusCode: httpStatus.BAD_REQUEST, body: 'invalid params', headers }
    }

    // 1、校验邮箱格式
    if (!validateEmail(email)) {
      return { statusCode: httpStatus.BAD_REQUEST, body: 'invalid email', headers }
    }

    // 2、生成四位随机数
    const randomCode = random(1000, 9999)

    // 3、将验证码插入到数据库中
    await collection.insertOne({
      email,
      code: randomCode,
      createTime: Date.now(),
      updateTime: Date.now()
    })

    // 4、发送邮件
    await sendEmail({
      user: process.env.EMAIL_USER,
      password: process.env.EMAIL_PASSWORD,
      code: randomCode
    })

    return {
      statusCode: httpStatus.OK,
      headers,
    }
  } catch (error) {
    if (error instanceof MongoServerError) {
      return { statusCode: httpStatus.INTERNAL_SERVER_ERROR, body: error, headers }
    }
    return { statusCode: httpStatus.INTERNAL_SERVER_ERROR, body: (error as any).message, headers }
  }
}

export { handler }

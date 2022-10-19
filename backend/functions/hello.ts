import { Handler } from '@netlify/functions'
import { MongoClient, MongoServerError } from 'mongodb'

// @ts-ignore
const client = new MongoClient(process.env.MONGODB_URI)
const clientPromise = client.connect()

const handler: Handler = async (event, context) => {
  try {
    const database = (await clientPromise).db(process.env.MONGODB_DATABASE)
    // @ts-ignore
    const collection = database.collection(process.env.MONGODB_COLLECTION)
    const results = collection.find().sort('score', 'descending').limit(10).toArray()

    return {
      statusCode: 200,
      body: JSON.stringify(results)
    }
  } catch (error) {
    if (error instanceof MongoServerError) {
      return { statusCode: 500, body: error }
    }
    return { statusCode: 500, body: (error as any).message }
  } finally {
    await client.close();
  }
}

export { handler }

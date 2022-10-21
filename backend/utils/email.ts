import nodemailer, { SentMessageInfo } from 'nodemailer'

export interface EmailProps {
  user: string;
  password: string;
  code: string;
  from?: string;
  to?: string;
  subject?: string;
  text?: string;
  html?: string;
}

export default async function sendEmail({ user, password, code }: EmailProps): Promise<SentMessageInfo> {
  // create reusable transporter object using the default SMTP transport
  let transporter = nodemailer.createTransport({
    host: "smtp.ethereal.email",
    port: 465,
    secure: true, // true for 465, false for other ports
    auth: {
      user, // generated ethereal user
      pass: password, // generated ethereal password
    },
  })

  // send mail with defined transport object
  let info = await transporter.sendMail({
    from: '"Fred Foo 👻" <foo@example.com>', // sender address
    to: "bar@example.com", // list of receivers
    subject: "Hello ✔", // Subject line
    text: "Hello world?", // plain text body
    html: `<b>Your code is ${code}.</b>`, // html body
  })

  return info
}

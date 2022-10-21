import nodemailer, { SentMessageInfo } from 'nodemailer'

export interface EmailProps {
  user?: string;
  password?: string;
  code?: number;
  from?: string;
  to?: string;
  subject?: string;
  text?: string;
  html?: string;
}

/**
 *
 * @param user
 * @param password
 * @param code
 * @param from
 * @param to
 * @param subject
 * @param text
 * @param html
 */
export async function sendEmail({ user, password, code, from, to, subject, text, html }: EmailProps): Promise<SentMessageInfo> {
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
    from: from || '"Fred Foo 👻" <foo@example.com>', // sender address
    to: to || "bar@example.com", // list of receivers
    subject: subject || "Hello ✔", // Subject line
    text: text || "Hello world?", // plain text body
    html: html || `<b>Your code is ${code}.</b>`, // html body
  })

  return info
}

const tester = /^[-!#$%&'*+\/0-9=?A-Z^_a-z`{|}~](\.?[-!#$%&'*+\/0-9=?A-Z^_a-z`{|}~])*@[a-zA-Z0-9](-*\.?[a-zA-Z0-9])*\.[a-zA-Z](-?[a-zA-Z0-9])+$/;

/**
 *
 * @param email
 */
export function validateEmail(email?: string): boolean {
  if (!email) return false;

  const emailParts = email.split('@');

  if(emailParts.length !== 2) return false

  const account = emailParts[0];
  const address = emailParts[1];

  if(account.length > 64) return false

  else if(address.length > 255) return false

  const domainParts = address.split('.');
  if (domainParts.some(function (part) {
    return part.length > 63;
  })) return false;


  if (!tester.test(email)) return false;

  return true;
}

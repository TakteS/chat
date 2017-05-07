import MainView from '../main';
import {Socket} from "phoenix"

export default class View extends MainView {
  mount() {
    super.mount();

    const token = window.chat.token
    const username = window.chat.username
    const roomId = window.room.id
    const messages = document.getElementById('messages')

    let socket = new Socket("/socket", {params: {token: token}})
    socket.connect()

    let channel = socket.channel(`room:${roomId}`, {})

    channel.join()
    channel.push(`join_room:${roomId}`, {token: token})

    setInterval(() => {
      channel.push(`show_online:${roomId}`, {token: token})
    }, 1000)

    channel.on(`join_room:${roomId}`, (e) => {
      const message = document.createElement('div')
      message.innerHTML = `<div class="system-message">${window.room.user} <b>${e.username}</b> ${window.room.joined}<hr></div>`
      document.getElementById('messages').appendChild(message)

      if (e.username == username) { messages.scrollTop = messages.scrollHeight }
    })

    channel.on(`show_online:${roomId}`, (e) => {
      const onlineUsers = e.online_users
      const onlineUsersElem = document.getElementById('online-users')

      onlineUsersElem.innerHTML = ''

      for (let i = 0; i < onlineUsers.length; i++) {
        onlineUsersElem.innerHTML += `${onlineUsers[i].username}<br />`
      }
    })

    channel.on(`new_message:${roomId}`, (e) => {
      const message = document.createElement('div')
      const messageText = e.message.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/"/g, '&quot;')

      if (e.username == username) {
        message.innerHTML = `<div class="own-message"><b>${window.room.youSay}: </b>${messageText}</div><hr>`
        messages.appendChild(message)
        messages.scrollTop = messages.scrollHeight
      }

      else {
        console.dir(message)
        message.innerHTML = `<div class="message"><b>${messageText} ${window.room.say}: </b>${message}</div><hr>`
        messages.appendChild(message)
      }
    })

    document.getElementById('send-button').onclick = () => {
      const message = document.getElementById('message-input')

      channel.push(`new_message:${roomId}`, {message: message.value, token: token})
      message.value = ""
    }
  }

  unmount() {
    super.unmount();
  }
}

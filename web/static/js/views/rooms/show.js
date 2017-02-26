import MainView from '../main';
import {Socket} from "phoenix"

export default class View extends MainView {
  mount() {
    super.mount();

    let token = window.chat.token
    let roomId = window.room.id
    let socket = new Socket("/socket", {params: {token: token}})
    socket.connect()

    let channel = socket.channel(`room:${roomId}`, {})

    channel.join()
    channel.push(`join_room:${roomId}`, {token: token})

    channel.on(`join_room:${roomId}`, (e) => {
      const message = document.createElement('div')
      message.innerHTML = `User <b>${e.username}</b> joined to the room!<hr>`
      document.getElementById('messages').appendChild(message)
    })

    channel.on(`new_message:${roomId}`, (e) => {
      const message = document.createElement('div')
      message.innerHTML = `<b>${e.username}</b> say: ${e.message}<hr>`
      document.getElementById('messages').appendChild(message)
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

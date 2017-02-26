import MainView from './main';
import RoomShowView from './rooms/show';

// Collection of specific view modules
const views = {
  RoomShowView,
};

export default function loadView(viewName) {
  return views[viewName] || MainView;
}

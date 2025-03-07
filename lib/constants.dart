import 'package:xml/xml.dart';

const List<String> epgUrl = [
  'https://gh-proxy.com/raw.githubusercontent.com/fanmingming/live/main/e.xml',
  'http://epg.51zmt.top:8000/e.xml',
  'https://epg.112114.xyz/pp.xml',
];

const List<String> channels = [
  'CCTV1',
  'CCTV2',
  'CCTV3',
  'CCTV4',
  'CCTV5',
  'CCTV5+',
  'CCTV6',
  'CCTV7',
  'CCTV8',
  'CCTV9',
  'CCTV10',
  'CCTV11',
  'CCTV12',
  'CCTV13',
  'CCTV14',
  'CCTV15',
  'CCTV16',
  'CCTV17',
  '高尔夫网球',
  'CCTV4K',
  'CCTV8K',
  '发现之旅',
  '女性时尚',
  '老故事',
  'CGTN',
  'CGTN纪录',
  'CETV1',
  'CETV2',
  'CETV3',
  'CETV4',
  '北京卫视',
  '东方卫视',
  '广东卫视',
  '江苏卫视',
  '湖南卫视',
  '浙江卫视',
  '安徽卫视',
  '深圳卫视',
  '贵州卫视',
  '山东卫视',
  '重庆卫视',
  '四川卫视',
  '河南卫视',
  '湖北卫视',
  '吉林卫视',
  '黑龙江卫视',
  '辽宁卫视',
  '江西卫视',
  '河北卫视',
  '东南卫视',
  '天津卫视',
  '海南卫视',
  '云南卫视',
  '广西卫视',
  '甘肃卫视',
  '青海卫视',
  '内蒙古卫视',
  '宁夏卫视',
  '山西卫视',
  '新疆卫视',
  '西藏卫视',
  '陕西卫视',
  '厦门卫视',
  '北京纪实',
  '凤凰中文',
  '凤凰资讯',
  '江苏新闻',
  '江苏城市',
  '江苏综艺',
  '江苏影视',
  '江苏体育休闲',
  '江苏教育',
  '江苏优漫卡通',
  '南京新闻综合',
  '南京文旅纪录',
  '南通新闻综合',
  '常州综合',
  '泰州一套',
  '泰州三套',
  'newtv中国功夫',
  'newtv军事评论',
  'newtv军旅剧场',
  '农业致富',
  'newtv动作电影',
  'newtv家庭剧场',
  'newtv怡伴健康',
  'newtv惊悚悬疑',
  '明星大片',
  'newtv武搏世界',
  'newtv潮妈辣婆',
  'newtv炫舞未来',
  'newtv爱情喜剧',
  'newtv精品体育',
  'newtv精品大剧',
  'newtv精品纪录',
  '精品萌宠',
  'newtv金牌综艺',
  '黑莓动画',
  '黑莓电影',
  '哒啵赛事',
  '纯享4K',
];

void format51zmtData(Iterable<XmlElement> programmes) {
  // 遍历所有 programme 标签，修改 channel 属性
  for (var programme in programmes) {
    var channelAttr = programme.getAttribute('channel');
    switch (channelAttr) {
      case '1':
        programme.setAttribute('channel', 'CCTV1');
        break;
      case '2':
        programme.setAttribute('channel', 'CCTV2');
        break;
      case '3':
        programme.setAttribute('channel', 'CCTV3');
        break;
      case '4':
        programme.setAttribute('channel', 'CCTV4');
        break;
      case '5':
        programme.setAttribute('channel', 'CCTV5');
        break;
      case '6':
        programme.setAttribute('channel', 'CCTV5+');
        break;
      case '7':
        programme.setAttribute('channel', 'CCTV6');
        break;
      case '8':
        programme.setAttribute('channel', 'CCTV7');
        break;
      case '9':
        programme.setAttribute('channel', 'CCTV8');
        break;
      case '10':
        programme.setAttribute('channel', 'CCTV9');
        break;
      case '11':
        programme.setAttribute('channel', 'CCTV10');
        break;
      case '12':
        programme.setAttribute('channel', 'CCTV11');
        break;
      case '13':
        programme.setAttribute('channel', 'CCTV12');
        break;
      case '14':
        programme.setAttribute('channel', 'CCTV13');
        break;
      case '15':
        programme.setAttribute('channel', 'CCTV14');
        break;
      case '16':
        programme.setAttribute('channel', 'CCTV15');
        break;
      case '7249':
        programme.setAttribute('channel', 'CCTV16');
        break;
      case '17':
        programme.setAttribute('channel', 'CCTV17');
        break;
      case '106':
        programme.setAttribute('channel', 'CCTV4K');
        break;
      case '6588':
        programme.setAttribute('channel', '发现之旅');
        break;
      case '6594':
        programme.setAttribute('channel', '老故事');
        break;
      case '20':
        programme.setAttribute('channel', 'CGTN');
        break;
      case '73':
        programme.setAttribute('channel', 'CETV1');
        break;
      case '74':
        programme.setAttribute('channel', 'CETV2');
        break;
      case '75':
        programme.setAttribute('channel', 'CETV3');
        break;
      case '30':
        programme.setAttribute('channel', '北京卫视');
        break;
      case '31':
        programme.setAttribute('channel', '东方卫视');
        break;
      case '33':
        programme.setAttribute('channel', '广东卫视');
        break;
      case '29':
        programme.setAttribute('channel', '江苏卫视');
        break;
      case '27':
        programme.setAttribute('channel', '湖南卫视');
        break;
      case '28':
        programme.setAttribute('channel', '浙江卫视');
        break;
      case '32':
        programme.setAttribute('channel', '安徽卫视');
        break;
      case '34':
        programme.setAttribute('channel', '深圳卫视');
        break;
      case '44':
        programme.setAttribute('channel', '贵州卫视');
        break;
      case '38':
        programme.setAttribute('channel', '山东卫视');
        break;
      case '40':
        programme.setAttribute('channel', '重庆卫视');
        break;
      case '56':
        programme.setAttribute('channel', '四川卫视');
        break;
      case '47':
        programme.setAttribute('channel', '河南卫视');
        break;
      case '48':
        programme.setAttribute('channel', '湖北卫视');
        break;
      case '51':
        programme.setAttribute('channel', '吉林卫视');
        break;
      case '46':
        programme.setAttribute('channel', '黑龙江卫视');
        break;
      case '36':
        programme.setAttribute('channel', '辽宁卫视');
        break;
      case '50':
        programme.setAttribute('channel', '江西卫视');
        break;
      case '45':
        programme.setAttribute('channel', '河北卫视');
        break;
      case '41':
        programme.setAttribute('channel', '东南卫视');
        break;
      case '39':
        programme.setAttribute('channel', '天津卫视');
        break;
      case '58':
        programme.setAttribute('channel', '云南卫视');
        break;
      case '43':
        programme.setAttribute('channel', '广西卫视');
        break;
      case '42':
        programme.setAttribute('channel', '甘肃卫视');
        break;
      case '59':
        programme.setAttribute('channel', '青海卫视');
        break;
      case '52':
        programme.setAttribute('channel', '内蒙古卫视');
        break;
      case '53':
        programme.setAttribute('channel', '宁夏卫视');
        break;
      case '54':
        programme.setAttribute('channel', '山西卫视');
        break;
      case '57':
        programme.setAttribute('channel', '新疆卫视');
        break;
      case '71':
        programme.setAttribute('channel', '西藏卫视');
        break;
      case '55':
        programme.setAttribute('channel', '陕西卫视');
        break;
      case '68':
        programme.setAttribute('channel', '厦门卫视');
        break;
      case '1872':
        programme.setAttribute('channel', '北京纪实');
        break;
      default:
        break;
    }
  }
}

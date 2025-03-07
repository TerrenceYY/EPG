import 'dart:convert';

import 'package:epg/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:xml/xml.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EPG',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'EPG'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _xmlData = '';
  late String _today;
  late String _tomorrow;

  @override
  Widget build(BuildContext context) {
    // 获取当前日期
    DateTime now = DateTime.now();
    _today = DateFormat('yyyyMMdd').format(now);
    _tomorrow = DateFormat('yyyyMMdd').format(now.add(Duration(days: 1)));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Row(
              children: [
                SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      showBottomSheet(context, epgUrl);
                      //fetchXml();
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text("获取EPG"),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      copyToClipboard(context);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text("复制"),
                  ),
                ),
                SizedBox(width: 8),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: SelectableText(
                  _xmlData,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showBottomSheet(BuildContext context, List<String> dataList) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(8),
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: dataList.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(dataList[index]),
                onTap: () {
                  fetchXml(index);
                  Navigator.pop(context);
                },
              );
            },
            separatorBuilder: (context, index) => Divider(),
          ),
        );
      },
    );
  }

  Future<void> fetchXml(int index) async {
    setState(() {
      _xmlData = '正在加载 XML 数据...';
    });

    try {
      final response = await get(Uri.parse(epgUrl[index]));
      if (response.statusCode == 200) {
        // 防止中文乱码
        final decodedBody = utf8.decode(response.bodyBytes);
        final document = XmlDocument.parse(decodedBody);
        var programmes = document.findAllElements('programme');

        Iterable<XmlElement> filterPrograms;

        if (index == 1) {
          filterPrograms = programmes.where((programme) {
            var start = programme.getAttribute('start');
            return start?.startsWith(_tomorrow) ?? false;
          });
          format51zmtData(filterPrograms);
        }

        filterPrograms = programmes.where((programme) {
          var channel = programme.getAttribute('channel');
          return channels.contains(channel);
        });

        final builder = XmlBuilder();

        builder.comment(' ${index == 1 ? _tomorrow : _today} ');
        for (var programme in filterPrograms) {
          builder.element('programme', attributes: {
            'channel': programme.getAttribute('channel') ?? '',
            'start': programme.getAttribute('start') ?? '',
            'stop': programme.getAttribute('stop') ?? '',
          }, nest: () {
            for (var title in programme.findElements('title')) {
              builder.element('title',
                  attributes: {
                    'lang': title.getAttribute('lang') ?? '',
                  },
                  nest: title.innerText);
            }
          });
        }

        final newXml = builder.buildDocument().toXmlString(pretty: true);

        setState(() {
          _xmlData = newXml;
        });
      } else {
        setState(() {
          _xmlData = "获取 XML 失败: 状态码 ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        _xmlData = "请求失败: $e";
      });
    }
  }

  void copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: _xmlData)).then((_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("已复制到剪贴板")),
        );
      });
    }).catchError((error) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("复制失败: $error")),
        );
      });
    });
  }
}

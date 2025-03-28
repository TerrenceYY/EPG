import 'dart:convert';
import 'dart:io';

import 'package:epg/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:xml/xml.dart';

/// 多天EPG
class EpgMorePage extends StatefulWidget {
  const EpgMorePage({super.key});

  @override
  State<EpgMorePage> createState() => _EpgMorePageState();
}

class _EpgMorePageState extends State<EpgMorePage> {
  String _xmlData = '';
  late String _today;
  late String _sixDaysAgo;
  late String _tomorrow;
  late XmlDocument curDocument;
  late XmlElement curTvNode;

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    _today = DateFormat('yyyyMMdd').format(now);
    _sixDaysAgo =
        DateFormat('yyyyMMdd').format(now.subtract(Duration(days: 6)));
    _tomorrow = DateFormat('yyyyMMdd').format(now.add(Duration(days: 1)));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('EPG MORE'),
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
                      showCurBottomSheet(context, curEpgUrl);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text('Cur EPG'),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      showNewBottomSheet(context, newEpgUrl);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text('New EPG'),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      shareXmlWithoutSaving(_xmlData);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text('Share'),
                  ),
                ),
                SizedBox(width: 8),
              ],
            ),
            Expanded(
              child: Scrollbar(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: SelectableText(
                    _xmlData,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showCurBottomSheet(BuildContext context, List<String> dataList) {
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
                  getCurXml(index);
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

  Future<void> getCurXml(int index) async {
    setState(() {
      _xmlData = '正在加载 XML 数据...';
    });

    try {
      final response = await get(Uri.parse(curEpgUrl[index]));
      if (response.statusCode == 200) {
        // 防止中文乱码
        //final decodedBody = utf8.decode(response.bodyBytes);
        curDocument = XmlDocument.parse(response.body);
        curTvNode = curDocument.rootElement;

        curTvNode.children.removeWhere((node) {
          if (node is XmlElement && node.name.local == 'programme') {
            final startAttr = node.getAttribute('start');
            var date = startAttr?.substring(0, 8) ?? '';
            var compareTo1 = _sixDaysAgo.compareTo(date);
            var compareTo2 = _today.compareTo(date);
            return compareTo1 >= 0 || compareTo2 == 0;
          }
          return false;
        });

        setState(() {
          _xmlData = curDocument.toXmlString(pretty: true);
        });
      } else {
        setState(() {
          _xmlData = '获取 XML 失败: 状态码 ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _xmlData = '请求失败: $e';
      });
    }
  }

  void showNewBottomSheet(BuildContext context, List<String> dataList) {
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
                  getNewXml(index);
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

  Future<void> getNewXml(int index) async {
    setState(() {
      _xmlData = '正在加载 XML 数据...';
    });

    try {
      final response = await get(Uri.parse(newEpgUrl[index]));
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

        for (var programme in filterPrograms) {
          curTvNode.children.add(programme.copy());
        }

        setState(() {
          _xmlData = curDocument.toXmlString(pretty: true);
        });
      } else {
        setState(() {
          _xmlData = '获取 XML 失败: 状态码 ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _xmlData = '请求失败: $e';
      });
    }
  }

  Future<void> shareXmlWithoutSaving(String xmlContent) async {
    try {
      Directory tempDir = await getTemporaryDirectory();
      String filePath = '${tempDir.path}/epg_more.xml';

      File tempFile = File(filePath);
      await tempFile.writeAsString(xmlContent);
      await Share.shareXFiles([XFile(filePath, mimeType: 'application/xml')]);

      Future.delayed(Duration(seconds: 1), () {
        if (tempFile.existsSync()) {
          tempFile.deleteSync();
          showSnackBar('保存成功！ XML 文件已删除: $filePath');
        }
      });
    } catch (e) {
      showSnackBar('分享 XML 失败: $e');
    }
  }

  void showSnackBar(String content) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(content)),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'dart:math';

import 'package:rust_genetics/widgets.dart';
import 'package:rust_genetics/pages.dart';
import 'package:rust_genetics/dialogs.dart';

var wregex = RegExp(r'W');
var xregex = RegExp(r'X');
var gregex = RegExp(r'G');
var yregex = RegExp(r'Y');
var hregex = RegExp(r'H');

Function eq = const ListEquality().equals;


Future<bool> run(context, _plants, String ideal, [bool skip_check = false]) async {
  try {
    // _plants = ['YHYYGH','YGYHGH','GGGWGY','GGGXYH','HHGGHX','WYYGHH','YHGWYH','GGHXGH','GHYXYH','WYGGHX','GYHWGY','WYGXWY'];
    // _plants = ['YGYHGH','GYHWGY','WYGXWY','YHYYGH','GGGWGY'];
    print(_plants);
    if (_plants.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Atleast 4 clones required'))
      );
      return true;
    }
    var plants = [];
    for (var plant in _plants) {
      plants.add(new Genetic(plant, false, plants.length, []));
    }

    //Insert Clone genetics. Try to add only 4+ green or max of 2 red genes. If you sort by best genes then it runs faster
    var g_count = 'G'.allMatches(ideal).length;
    var y_count = 'Y'.allMatches(ideal).length;
    var h_count = 'H'.allMatches(ideal).length;

    if (!skip_check) {
      int percentage = checkIfPossible(plants, g_count, y_count, h_count);
      if (percentage <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$percentage% chance of solution'))
        );
        return true;
      } else if (percentage < 50) {
        errorDialog(context, percentage, _plants, ideal);
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$percentage% chance of solution'))
        );
      }
    }

    // ignore: non_constant_identifier_names
    var temp_arr = [];
    var result;
    var done = false;
    // ignore: non_constant_identifier_names
    var plants_len;

    for (var x = 1; x <= 3; x++) {
      plants_len = plants.length;
      if (done) {
        List<List<Map<String, Object>>> test_ar = [];
        int row_count = 1;
        var res_json = {};
        var pos_1 = plants_len-1;
        var key_1 = plants[pos_1].key;
        var key_2;
        var parents = false;
        test_ar.insert(0, [
          {
            'fifty_fifty': plants[pos_1].fifty_fifty
          }
        ]);
        if (((gregex.allMatches(key_1)).length == g_count) && ((yregex.allMatches(key_1)).length == y_count)) {
        // last result is solution
          res_json[key_1] = plants[pos_1];
          if (plants[pos_1].parents.length > 0) {
            test_ar.insert(0, [
              {
                'fifty_fifty': plants[pos_1].fifty_fifty
              }
            ]);
            var keys1 = [];
            var keys2 = [];
            for (var l in plants[pos_1].parents) {
              key_2 = plants[l].key;
              keys1.add(key_2);
              res_json[key_2] = plants[l];
              if (plants[l].parents.length > 0) {
                parents = false;
                for (var ky in plants[l].parents) {
                  if (!_plants.contains(plants[ky].key)) parents = true;
                }
                if (parents) {
                  row_count++;
                  test_ar.insert(0, [
                    {
                      'fifty_fifty': plants[l].fifty_fifty
                    }
                  ]);
                }
                for (var m in plants[l].parents) {
                  var key_3 = plants[m].key;
                  keys2.add(key_3);
                  res_json[key_3] = plants[m];
                }
                // add the resulting gene to be displayed
                if (keys2.length > 0) {
                  parents = false;
                  for (var ky in keys2) {
                    if (!_plants.contains(ky)) parents = true;
                  }
                  keys2.add(key_2);
                  if (parents) {
                    test_ar[0][0]['plants'] = keys2;
                  } else {
                    test_ar[0].add({
                      'fifty_fifty': plants[l].fifty_fifty,
                      'plants': keys2
                    });
                  }
                  keys2=[];
                }
              }
            }
            if (keys1.length > 0) {
              keys1.add(key_1);
              test_ar[row_count][0]['plants'] = keys1;
            }
          }
        }
        // 2nd to last is solution
        else {
          var pos_1 = plants_len-2;
          var key_1 = plants[pos_1].key;
          res_json[key_1] = plants[pos_1];
          if (plants[pos_1].parents.length > 0) {
            test_ar.insert(0, [
              {
                'fifty_fifty': plants[pos_1].fifty_fifty
              }
            ]);
            var keys1 = [];
            var keys2 = [];
            for (var l in plants[pos_1].parents) {
              key_2 = plants[l].key;
              keys1.add(key_2);
              res_json[key_2] = plants[l];
              if (plants[l].parents.length > 0) {
                parents = false;
                for (var ky in plants[l].parents) {
                  if (!_plants.contains(plants[ky].key)) parents = true;
                }
                if (parents) {
                  row_count++;
                  test_ar.insert(0, [
                    {
                      'fifty_fifty': plants[l].fifty_fifty
                    }
                  ]);
                }
                for (var m in plants[l].parents) {
                  var key_3 = plants[m].key;
                  keys2.add(key_3);
                  res_json[key_3] = plants[m];
                }
                // add the resulting gene to be displayed
                if (keys2.length > 0) {
                  parents = false;
                  for (var ky in keys2) {
                    if (!_plants.contains(ky)) parents = true;
                  }
                  keys2.add(key_2);
                  if (parents) {
                    test_ar[0][0]['plants'] = keys2;
                  } else {
                    test_ar[0].add({
                      'fifty_fifty': plants[l].fifty_fifty,
                      'plants': keys2
                    });
                  }
                  keys2=[];
                }
              }
            }
            if (keys1.length > 0) {
              keys1.add(key_1);
              test_ar[row_count][0]['plants'] = keys1;
            }
          }
        }

        // remove incomplete values to prevent breaks during rendering
        for (var n = test_ar.length-1; n >= 0; n--) {
          for (var o = test_ar[n].length-1; o >= 0; o--) {
            if (test_ar[n][o]['plants'] == null) {
              test_ar[n].removeAt(o);
              if (test_ar[n].length == 0) {
                test_ar.removeAt(n);
              }
            }
          }
        }
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ResultPage(test_ar)),
        );
        return true;
      }

      for (var k1 = 0; k1 < plants_len; k1++) {
        if (done) {break;}
        loop2:
        for (var k2 = 0; k2 < plants_len; k2++) {
          await Future.delayed(Duration(microseconds: 1));
          if (done) {break;}
          if (k1 == k2) {
            // only use the same plant twice if its 6 green plant
            if (plants[k2].key.indexOf('W') != -1) {
              continue loop2;
            }
            if (plants[k2].key.indexOf('X') != -1) {
              continue loop2;
            }
          }
          loop3:
          for (var k3 = 0; k3 < plants_len; k3++) {
            if (done) {break;}
            if (k1 == k3) {continue loop3;}
            if (k2 == k3) {continue loop3;}
            loop4:
            for (var k4 = 0; k4 < plants_len; k4++) {
              if (done) {break;}
              if (k1 == k4) {continue loop4;}
              if (k2 == k4) {continue loop4;}
              if (k3 == k4) {continue loop4;}
              temp_arr.add(plants[k1]);
              temp_arr.add(plants[k2]);
              temp_arr.add(plants[k3]);
              temp_arr.add(plants[k4]);
              if (plants.length == 39) {
                print('39');
              }
              result = geneCalc(temp_arr, g_count, y_count, h_count);
              
              temp_arr = [];

              if (result['fifty_fifty']) {
                if (result['res1'] != null) {
                  var keys = [];
                  for (var l in plants) {
                    keys.add(l.key);
                  }
                  if (keys.indexOf(result['res1']) == -1) {
                    plants.add(new Genetic(result['res1'], true, plants.length, [plants[k1].id, plants[k2].id, plants[k3].id, plants[k4].id]));
                  }
                }
                if (result['res2'] != null) {
                  var keys = [];
                  for (var l in plants) {
                    keys.add(l.key);
                  }
                  if (keys.indexOf(result['res2']) == -1) {
                    plants.add(new Genetic(result['res2'], true, plants.length, [plants[k1].id, plants[k2].id, plants[k3].id, plants[k4].id]));
                  }

                }
                if (result['done']) {
                  done = true;
                  break;
                }
              } else if (result['res1'] != null) {
                var keys = [];
                for (var l in plants) {
                  keys.add(l.key);
                }
                if (keys.indexOf(result['res1']) == -1) {
                  plants.add(new Genetic(result['res1'], false, plants.length, [plants[k1].id, plants[k2].id, plants[k3].id, plants[k4].id]));
                }
                if (result['done']) {
                  done = true;
                  break;
                }
              }
            }
          }
        }
      }
    }
    noSolutionDialog(context);
    return true;
  } catch (e) {
    print(e);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.toString()))
    );
    return true;
  }
}

Map<dynamic, dynamic> check(gene_temp, g_count, y_count, h_count) {
  var rtrn = {};
  var temp_arr = fiftyFiftyCheck(gene_temp);
  var res1 = temp_arr[0];
  var res2 = temp_arr[1];
  var fifty_fifty = temp_arr[2];


  if (fifty_fifty) {
    rtrn['fifty_fifty'] = true;
    if ((wregex.allMatches(res1)).length > 1) {rtrn['done']=false;rtrn['res1']=null;}
    else if ((xregex.allMatches(res1)).length > 1) {rtrn['done']=false;rtrn['res1']=null;}
    else if (((wregex.allMatches(res1)).length > 0) && ((xregex.allMatches(res1)).length > 0)) {rtrn['done']=false;rtrn['res1']=null;}
    else if (((gregex.allMatches(res1)).length == g_count) && ((yregex.allMatches(res1)).length == y_count)) {
      print('FINISHED!!!!');
      rtrn['done']=true;rtrn['res1']=res1;
    } else {
      rtrn['done']=false;rtrn['res1']=res1;
    }
    if (rtrn['done'] == false) {
      if ((wregex.allMatches(res2)).length > 1) {rtrn['done']=false;rtrn['res2']=null;}
      else if ((xregex.allMatches(res2)).length > 1) {rtrn['done']=false;rtrn['res2']=null;}
      else if (((wregex.allMatches(res2)).length > 0) && ((xregex.allMatches(res2)).length > 0)) {rtrn['done']=false;rtrn['res2']=null;}
      else if (((gregex.allMatches(res2)).length == g_count) && ((yregex.allMatches(res2)).length == y_count)) {
        print('FINISHED!!!!');
        rtrn['done']=true;rtrn['res2']=res2;
      } else {
        rtrn['done']=false;rtrn['res2']=res2;
      }
    }

    return rtrn;
  } else {
    rtrn['fifty_fifty'] = false;
    if ((wregex.allMatches(res1)).length > 1) {rtrn['done']=false;rtrn['res1']=null;}
    else if ((xregex.allMatches(res1)).length > 1) {rtrn['done']=false;rtrn['res1']=null;}
    else if (((wregex.allMatches(res1)).length > 0) && ((xregex.allMatches(res1)).length > 0)) {rtrn['done']=false;rtrn['res1']=null;}
    else if (((gregex.allMatches(res1)).length == g_count) && ((yregex.allMatches(res1)).length == y_count)) {
      print('FINISHED!!!!');
      rtrn['done']=true;rtrn['res1']=res1;
    } else {
      rtrn['done']=false;rtrn['res1']=res1;
    }
    
    return rtrn;
  }
}

Map<dynamic, dynamic> geneCalc(obj, g_count, y_count, h_count) {
  //ghy=0,6  xw=1
  var gene_temp = {1:[],2:[],3:[],4:[],5:[],6:[]};
  
  obj.forEach((z) {
    var key = z.key;
    gene_temp[1].add(key[0]);
    gene_temp[2].add(key[1]);
    gene_temp[3].add(key[2]);
    gene_temp[4].add(key[3]);
    gene_temp[5].add(key[4]);
    gene_temp[6].add(key[5]);
  });
  var new_gene;
  new_gene = check(gene_temp, g_count, y_count, h_count);
  
  return new_gene;
}

int checkIfPossible(plants, g_count, y_count, h_count) {
  var ideal = {
    'G1':0,'G1':0,'G2':0,'G3':0,'G4':0,'G5':0,'G6':0,
    'Y1':0,'Y1':0,'Y2':0,'Y3':0,'Y4':0,'Y5':0,'Y6':0,
    'H1':0,'H1':0,'H2':0,'H3':0,'H4':0,'H5':0,'H6':0,
  };
  for (var plant in plants) {
    var gene_temp1 = plant.key;
    if (gene_temp1[0] == 'G') {
      ideal['G1']++;
      //if a seed has 6 greens, then we sometimes use 2 of these seeds in cloning.
      //thus increment once more just so that the percentage isn't 0
      if (gene_temp1.indexOf('X') == -1 && gene_temp1.indexOf('W') == -1) {
        ideal['G1']++;
      }
    }
    if (gene_temp1[0] == 'Y') {
      ideal['Y1']++;
      if (gene_temp1.indexOf('X') == -1 && gene_temp1.indexOf('W') == -1) {
        ideal['Y1']++;
      }
    }
    if (gene_temp1[0] == 'H') {
      ideal['H1']++;
      if (gene_temp1.indexOf('X') == -1 && gene_temp1.indexOf('W') == -1) {
        ideal['H1']++;
      }
    }
    if (gene_temp1[1] == 'G') {
      ideal['G2']++;
      if (gene_temp1.indexOf('X') == -1 && gene_temp1.indexOf('W') == -1) {
        ideal['G2']++;
      }
    }
    if (gene_temp1[1] == 'Y') {
      ideal['Y2']++;
      if (gene_temp1.indexOf('X') == -1 && gene_temp1.indexOf('W') == -1) {
        ideal['Y2']++;
      }
    }
    if (gene_temp1[1] == 'H') {
      ideal['H2']++;
      if (gene_temp1.indexOf('X') == -1 && gene_temp1.indexOf('W') == -1) {
        ideal['H2']++;
      }
    }
    if (gene_temp1[2] == 'G') {
      ideal['G3']++;
      if (gene_temp1.indexOf('X') == -1 && gene_temp1.indexOf('W') == -1) {
        ideal['G3']++;
      }
    }
    if (gene_temp1[2] == 'Y') {
      ideal['Y3']++;
      if (gene_temp1.indexOf('X') == -1 && gene_temp1.indexOf('W') == -1) {
        ideal['Y3']++;
      }
    }
    if (gene_temp1[2] == 'H') {
      ideal['H3']++;
      if (gene_temp1.indexOf('X') == -1 && gene_temp1.indexOf('W') == -1) {
        ideal['H3']++;
      }
    }
    if (gene_temp1[3] == 'G') {
      ideal['G4']++;
      if (gene_temp1.indexOf('X') == -1 && gene_temp1.indexOf('W') == -1) {
        ideal['G4']++;
      }
    }
    if (gene_temp1[3] == 'Y') {
      ideal['Y4']++;
      if (gene_temp1.indexOf('X') == -1 && gene_temp1.indexOf('W') == -1) {
        ideal['Y4']++;
      }
    }
    if (gene_temp1[3] == 'H') {
      ideal['H4']++;
      if (gene_temp1.indexOf('X') == -1 && gene_temp1.indexOf('W') == -1) {
        ideal['H4']++;
      }
    }
    if (gene_temp1[4] == 'G') {
      ideal['G5']++;
      if (gene_temp1.indexOf('X') == -1 && gene_temp1.indexOf('W') == -1) {
        ideal['G5']++;
      }
    }
    if (gene_temp1[4] == 'Y') {
      ideal['Y5']++;
      if (gene_temp1.indexOf('X') == -1 && gene_temp1.indexOf('W') == -1) {
        ideal['Y5']++;
      }
    }
    if (gene_temp1[4] == 'H') {
      ideal['H5']++;
      if (gene_temp1.indexOf('X') == -1 && gene_temp1.indexOf('W') == -1) {
        ideal['H5']++;
      }
    }
    if (gene_temp1[5] == 'G') {
      ideal['G6']++;
      if (gene_temp1.indexOf('X') == -1 && gene_temp1.indexOf('W') == -1) {
        ideal['G6']++;
      }
    }
    if (gene_temp1[5] == 'Y') {
      ideal['Y6']++;
      if (gene_temp1.indexOf('X') == -1 && gene_temp1.indexOf('W') == -1) {
        ideal['Y6']++;
      }
    }
    if (gene_temp1[5] == 'H') {
      ideal['H6']++;
      if (gene_temp1.indexOf('X') == -1 && gene_temp1.indexOf('W') == -1) {
        ideal['H6']++;
      }
    }
  }
  var percentage = 99;
  var ycount = 0;
  var gcount = 0;
  var hcount = 0;
  for (var k = 1; k <= 6; k++) {
    if (ideal['G'+k.toString()] <= 1 && ideal['Y'+k.toString()] <= 1 && ideal['H'+k.toString()] <= 1 && g_count > 0 && y_count > 0 && h_count > 0) {
      percentage = 0;
      break;
    }
    else if (ideal['G'+k.toString()] <= 1 && ideal['Y'+k.toString()] <= 1 && g_count > 0 && y_count > 0) {
      percentage = 0;
      break;
    }
    else if (ideal['G'+k.toString()] <= 1 && g_count == 6) {
      percentage = 0;
      break;
    }
    else if (ideal['Y'+k.toString()] <= 1 && y_count == 6) {
      percentage = 0;
      break;
    }
    else if (ideal['H'+k.toString()] <= 1 && h_count == 6) {
      percentage = 0;
      break;
    }
    else if (ideal['G'+k.toString()] <= 2 && ideal['Y'+k.toString()] <= 2 && ideal['H'+k.toString()] <= 2 && g_count > 0 && y_count > 0 && h_count > 0) {
      percentage -= 10;
    }
    else if (ideal['G'+k.toString()] <= 2 && ideal['Y'+k.toString()] <= 2 && g_count > 0 && y_count > 0 && h_count == 0) {
      percentage -= 10;
    }
    else if (ideal['G'+k.toString()] == 2 && y_count == 0 && h_count == 0) {
      percentage -= 10;
    }
    else if (ideal['Y'+k.toString()] == 2 && g_count == 0 && h_count == 0) {
      percentage -= 10;
    }
    else if (ideal['H'+k.toString()] == 2 && g_count == 0 && y_count == 0) {
      percentage -= 10;
    }
    else if (ideal['G'+k.toString()] <= 3 && ideal['Y'+k.toString()] <= 3 && ideal['H'+k.toString()] <= 3 && g_count > 0 && y_count > 0 && h_count > 0) {
      percentage -= 5;
    }
    else if (ideal['G'+k.toString()] <= 3 && ideal['Y'+k.toString()] <= 3 && g_count > 0 && y_count > 0 && h_count > 0) {
      percentage -= 5;
    }
    else if (ideal['G'+k.toString()] == 3 && y_count == 0 && h_count == 0) {
      percentage -= 5;
    }
    else if (ideal['Y'+k.toString()] == 3 && g_count == 0 && h_count == 0) {
      percentage -= 5;
    }
    else if (ideal['H'+k.toString()] == 3 && g_count == 0 && y_count == 0) {
      percentage -= 5;
    }
    
    if (ideal['G'+k.toString()] >= 2) {gcount += 1;}
    if (ideal['Y'+k.toString()] >= 2) {ycount += 1;}
    if (ideal['H'+k.toString()] >= 2) {hcount += 1;}
  }
  
  if (gcount < g_count) {percentage -= 50;}
  if (ycount < y_count) {percentage -= 50;}
  if (hcount < h_count) {percentage -= 50;}
  if (percentage < 0) percentage = 0;
  return percentage;
}

List fiftyFiftyCheck(gene_temp) {
  var res1 = '';
  var res2 = '';
  var fifty_fifty = false;
  var fifty_idx = {'g':[],'y':[],'h':[]};
  var plant_pairs = [];
  var g = 0.0;var y = 0.0;var h = 0.0;var w = 0.0;var x = 0.0; var dmax = 0.0;
  for (var k = 1; k <= 6; k++) {
    g = 0.0; y = 0.0; h = 0.0; w = 0.0; x = 0.0; dmax = 0.0; fifty_idx = {'g':[],'y':[],'h':[]};
    // check for 4 plants only
    for (var l=0; l<4; l++) {
      if (gene_temp[k][l] == 'G') { g += 0.6;fifty_idx['g'].add(l); }
      if (gene_temp[k][l] == 'Y') { y += 0.6;fifty_idx['y'].add(l); }
      if (gene_temp[k][l] == 'H') { h += 0.6;fifty_idx['h'].add(l); }
      if (gene_temp[k][l] == 'W') { w += 1.0; }
      if (gene_temp[k][l] == 'X') { x += 1.0; }
    }
    dmax = [g,y,h,w,x].reduce(max);
    if (w == dmax) {res1 += 'W';res2 += 'W';}
    else if (x == dmax) {res1 += 'X';res2 += 'X';}
    else if (g == dmax && y == dmax) {
      // handle the weird 50/50 bug
      if (plant_pairs.length == 0) {
        plant_pairs.add(fifty_idx['g']);
        plant_pairs.add(fifty_idx['y']);
        res1 += 'G';res2 += 'Y';fifty_fifty=true;
      } else {
        if (eq(fifty_idx['g'], plant_pairs[0])) {
          res1 += 'G';res2 += 'Y';fifty_fifty=true;
        } else if (eq(fifty_idx['g'], plant_pairs[1])) {
          res1 += 'Y';res2 += 'G';fifty_fifty=true;
        } else {
          res1 += 'G';res2 += 'Y';fifty_fifty=true;
        }
      }
    }
    else if (g == dmax && h == dmax) {
      // handle the weird 50/50 bug
      if (plant_pairs.length == 0) {
        plant_pairs.add(fifty_idx['g']);
        plant_pairs.add(fifty_idx['h']);
        res1 += 'G';res2 += 'H';fifty_fifty=true;
      } else {
        if (eq(fifty_idx['g'], plant_pairs[0])) {
          res1 += 'G';res2 += 'H';fifty_fifty=true;
        } else if (eq(fifty_idx['g'], plant_pairs[1])) {
          res1 += 'H';res2 += 'G';fifty_fifty=true;
        } else {
          res1 += 'G';res2 += 'H';fifty_fifty=true;
        }
      }
    }
    else if (y == dmax && h == dmax) {
      // handle the weird 50/50 bug
      if (plant_pairs.length == 0) {
        plant_pairs.add(fifty_idx['y']);
        plant_pairs.add(fifty_idx['h']);
        res1 += 'Y';res2 += 'H';fifty_fifty=true;
      } else {
        if (eq(fifty_idx['y'], plant_pairs[0])) {
          res1 += 'Y';res2 += 'H';fifty_fifty=true;
        } else if (eq(fifty_idx['y'], plant_pairs[1])) {
          res1 += 'H';res2 += 'Y';fifty_fifty=true;
        } else {
          res1 += 'Y';res2 += 'H';fifty_fifty=true;
        }
      }
    }
    else if (g == dmax) {res1 += 'G';res2 += 'G';}
    else if (y == dmax) {res1 += 'Y';res2 += 'Y';}
    else if (h == dmax) {res1 += 'H';res2 += 'H';}
  }
  
  return [res1, res2, fifty_fifty];
}
import 'package:test/test.dart';
import 'package:webthree/webthree.dart';

// https://github.com/ethereum/wiki/wiki/JSON-RPC#the-default-block-parameter
const blockParameters = {
  'latest': BlockNum.current(),
  'earliest': BlockNum.genesis(),
  'pending': BlockNum.pending(),
  '0x40': BlockNum.exact(64),
};

void main() {
  test('block parameters encode', () {
    blockParameters.forEach((encoded, block) {
      expect(block.toBlockParam(), encoded);
    });
  });

  test('pending block param is pending', () {
    expect(const BlockNum.pending().isPending, true);
  });
}

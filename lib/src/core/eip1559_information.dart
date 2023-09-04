part of webthree;

class EIP1559Information {
  EIP1559Information({
    required this.lastBaseFeePerGas,
    required this.maxPriorityFeePerGas,
    required this.maxFeePerGas,
    required this.estimatedGas,
  });

  factory EIP1559Information.fromJson(Map<String, String> json) =>
      EIP1559Information(
        lastBaseFeePerGas: EtherAmount.inWei(BigInt.parse(json['baseFee']!)),
        maxPriorityFeePerGas:
            EtherAmount.inWei(BigInt.parse(json['maxPriorityFeePerGas']!)),
        maxFeePerGas: EtherAmount.inWei(BigInt.parse(json['maxFeePerGas']!)),
        estimatedGas: BigInt.parse(json['estimatedGas']!),
      );

  Map<String, String> toJson() => {
        'lastBaseFeePerGas': lastBaseFeePerGas.toString(),
        'maxPriorityFeePerGas': maxPriorityFeePerGas.getInWei.toString(),
        'maxFeePerGas': maxFeePerGas.getInWei.toString(),
        'estimatedGas': estimatedGas.toString(),
      };

  final EtherAmount lastBaseFeePerGas;
  final EtherAmount maxPriorityFeePerGas;
  final EtherAmount maxFeePerGas;
  final BigInt estimatedGas;
}

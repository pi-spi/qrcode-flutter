import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:qr/qr.dart';

import 'qr_painter.dart';
import 'types.dart';

/// A widget that shows a QR code.
class QrImageView extends StatefulWidget {
  /// Create a new QR code using the [String] data and the passed options (or
  /// using the default options).
  const QrImageView({
    required String data,
    super.key,
    this.size,
    this.padding = const EdgeInsets.all(10.0),
    this.backgroundColor = Colors.transparent,
    this.errorCorrectionLevel = QrErrorCorrectLevel.L,
    this.errorStateBuilder,
    this.constrainErrorBounds = true,
    this.embedded,
    this.semanticsLabel = 'qr code',
    this.eyeStyle = const QrImageOptionsEye(
      shape: QrEyeShape.square,
      color: Colors.black,
    ),
    this.dataModuleStyle = const QrImageOptionsData(
      shape: QrDataShape.square,
      color: Colors.black,
    ),
    this.embeddedImageEmitsError = false,
    @Deprecated('use colors in eyeStyle and dataModuleStyle instead')
        this.foregroundColor,
  })  : 
        _data = data,
        _qrCode = null;

  /// Create a new QR code using the [QrCode] data and the passed options (or
  /// using the default options).
  const QrImageView.withQr({
    required QrCode qr,
    super.key,
    this.size,
    this.padding = const EdgeInsets.all(10.0),
    this.backgroundColor = Colors.transparent,
    this.errorCorrectionLevel = QrErrorCorrectLevel.L,
    this.errorStateBuilder,
    this.constrainErrorBounds = true,
    this.embedded,
    this.semanticsLabel = 'qr code',
    this.eyeStyle = const QrImageOptionsEye(
      shape: QrEyeShape.square,
      color: Colors.black,
    ),
    this.dataModuleStyle = const QrImageOptionsData(
      shape: QrDataShape.square,
      color: Colors.black,
    ),
    this.embeddedImageEmitsError = false,
    @Deprecated('use colors in eyeStyle and dataModuleStyle instead')
        this.foregroundColor,
  })  : 
        _data = null,
        _qrCode = qr;

  // The data passed to the widget
  final String? _data;

  // The QR code data passed to the widget
  final QrCode? _qrCode;

  /// The background color of the final QR code widget.
  final Color backgroundColor;

  /// The QR code error correction level to use.
  final int errorCorrectionLevel;

  /// The external padding between the edge of the widget and the content.
  final EdgeInsets padding;

  /// The intended size of the widget.
  final double? size;

  /// The callback that is executed in the event of an error so that you can
  /// interrogate the exception and construct an alternative view to present
  /// to your user.
  final QrErrorBuilder? errorStateBuilder;

  /// If `true` then the error widget will be constrained to the boundary of the
  /// QR widget if it had been valid. If `false` the error widget will grow to
  /// the size it needs. If the error widget is allowed to grow, your layout may
  /// jump around (depending on specifics).
  ///
  /// NOTE: Setting a [size] value will override this setting and both the
  /// content widget and error widget will adhere to the size value.
  final bool constrainErrorBounds;


  /// The image data to embed (as an overlay) in the QR code. The image will
  final QrEmbeddedImage? embedded;

  /// If set to true and there is an error loading the embedded image, the
  /// [errorStateBuilder] callback will be called (if it is defined). If false,
  /// the widget will ignore the embedded image and just display the QR code.
  /// The default is false.
  final bool embeddedImageEmitsError;

  /// [semanticsLabel] will be used by screen readers to describe the content of
  /// the qr code.
  /// Default is 'qr code'.
  final String semanticsLabel;

  /// Styling option for QR Eye ball and frame.
  final QrImageOptionsEye eyeStyle;

  /// Styling option for QR data module.
  final QrImageOptionsData dataModuleStyle;

  /// The foreground color of the final QR code widget.
  @Deprecated('use colors in eyeStyle and dataModuleStyle instead')
  final Color? foregroundColor;

  @override
  State<QrImageView> createState() => _QrImageViewState();
}

class _QrImageViewState extends State<QrImageView> {
  /// The QR code string data.
  QrCode? _qr;

  @override
  Widget build(BuildContext context) {
    if (widget._data != null) {
      _qr = QrCode.fromData(
          data: widget._data!,
          errorCorrectLevel: widget.errorCorrectionLevel,
        );
    } else if (widget._qrCode != null) {
      _qr = widget._qrCode;
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        // no error, build the regular widget
        final widgetSize =
            widget.size ?? constraints.biggest.shortestSide;
        if (widget.embedded?.image != null) {
          // if requesting to embed an image then we need to load via a
          // FutureBuilder because the image provider will be async.
          return FutureBuilder<ui.Image>(
            future: _loadQrImage(context, widget.embedded?.style),
            builder: (ctx, snapshot) {
              if (snapshot.error != null) {
                debugPrint('snapshot error: ${snapshot.error}');
                return widget.embeddedImageEmitsError
                    ? _errorWidget(context, constraints, snapshot.error)
                    : _qrWidget(null, widgetSize);
              }
              if (snapshot.hasData) {
                debugPrint('loaded image');
                final loadedImage = snapshot.data;
                return _qrWidget(loadedImage, widgetSize);
              } else {
                return Container();
              }
            },
          );
        } else {
          return _qrWidget(null, widgetSize);
        }
      },
    );
  }

  Widget _qrWidget(ui.Image? image, double edgeLength) {
    final painter = QrPainter.withQr(
      qr: _qr!,
      // ignore: deprecated_member_use_from_same_package
      color: widget.foregroundColor,
      embeddedImageStyle: widget.embedded?.style,
      embeddedImage: image,
      eyeStyle: widget.eyeStyle,
      dataModuleStyle: widget.dataModuleStyle,
    );
    return _QrContentView(
      edgeLength: edgeLength,
      backgroundColor: widget.backgroundColor,
      padding: widget.padding,
      semanticsLabel: widget.semanticsLabel,
      child: CustomPaint(painter: painter),
    );
  }

  Widget _errorWidget(
    BuildContext context,
    BoxConstraints constraints,
    Object? error,
  ) {
    final errorWidget = widget.errorStateBuilder == null
        ? Container()
        : widget.errorStateBuilder!(context, error);
    final errorSideLength = widget.constrainErrorBounds
        ? widget.size ?? constraints.biggest.shortestSide
        : constraints.biggest.longestSide;
    return _QrContentView(
      edgeLength: errorSideLength,
      backgroundColor: widget.backgroundColor,
      padding: widget.padding,
      semanticsLabel: widget.semanticsLabel,
      child: errorWidget,
    );
  }

  late ImageStreamListener streamListener;

  Future<ui.Image> _loadQrImage(
    BuildContext buildContext,
    QrEmbeddedImageStyle? style,
  ) {
    if (style != null) {}

    final mq = MediaQuery.of(buildContext);
    final completer = Completer<ui.Image>();
    final stream = widget.embedded!.image.resolve(
      ImageConfiguration(
        devicePixelRatio: mq.devicePixelRatio,
      ),
    );

    streamListener = ImageStreamListener(
      (info, err) {
        stream.removeListener(streamListener);
        completer.complete(info.image);
      },
      onError: (err, _) {
        stream.removeListener(streamListener);
        completer.completeError(err);
      },
    );
    stream.addListener(streamListener);
    return completer.future;
  }
}

/// A function type to be called when any form of error occurs while
/// painting a [QrImageView].
typedef QrErrorBuilder = Widget Function(BuildContext context, Object? error);

class _QrContentView extends StatelessWidget {
  const _QrContentView({
    required this.edgeLength,
    required this.child,
    this.backgroundColor,
    this.padding,
    this.semanticsLabel,
  });

  /// The length of both edges (because it has to be a square).
  final double edgeLength;

  /// The background color of the containing widget.
  final Color? backgroundColor;

  /// The padding that surrounds the child widget.
  final EdgeInsets? padding;

  /// The child widget.
  final Widget child;

  /// [semanticsLabel] will be used by screen readers to describe the content of
  /// the qr code.
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticsLabel,
      child: Container(
        width: edgeLength,
        height: edgeLength,
        color: backgroundColor,
        child: Padding(
          padding: padding!,
          child: child,
        ),
      ),
    );
  }
}

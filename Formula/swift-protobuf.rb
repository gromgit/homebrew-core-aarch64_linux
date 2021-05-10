class SwiftProtobuf < Formula
  desc "Plugin and runtime library for using protobuf with Swift"
  homepage "https://github.com/apple/swift-protobuf"
  url "https://github.com/apple/swift-protobuf/archive/1.16.0.tar.gz"
  sha256 "a8c06b3fb05b18d74bd63151f0074904e8223cbe8217d0c6cbb4fba470dfb766"
  license "Apache-2.0"
  head "https://github.com/apple/swift-protobuf.git"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6f02a7be1e42f1c071c66f86e2912706974971d9a694e7308e198b9b9b21101d"
    sha256 cellar: :any_skip_relocation, big_sur:       "7b351f6504a95a3406a2690117414dddd6fd8975b8af9613d4dcf20f72830aa4"
    sha256 cellar: :any_skip_relocation, catalina:      "9ca635f6bcd44e30783c98b2bd79c9ab14a3a29f9470f148aaae6d2c8ee8b9fc"
    sha256 cellar: :any_skip_relocation, mojave:        "b1e789bdfd0a2ee45b55e0eed5f60d0aef6184bc015863d8a1143bf839a5fc79"
  end

  depends_on xcode: ["8.3", :build]
  depends_on "protobuf"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/protoc-gen-swift"
    doc.install "Documentation/PLUGIN.md"
  end

  test do
    (testpath/"test.proto").write <<~EOS
      syntax = "proto3";
      enum Flavor {
        CHOCOLATE = 0;
        VANILLA = 1;
      }
      message IceCreamCone {
        int32 scoops = 1;
        Flavor flavor = 2;
      }
    EOS
    system Formula["protobuf"].opt_bin/"protoc", "test.proto", "--swift_out=."
    assert_predicate testpath/"test.pb.swift", :exist?
  end
end

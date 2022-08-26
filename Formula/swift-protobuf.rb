class SwiftProtobuf < Formula
  desc "Plugin and runtime library for using protobuf with Swift"
  homepage "https://github.com/apple/swift-protobuf"
  url "https://github.com/apple/swift-protobuf/archive/1.20.0.tar.gz"
  sha256 "a41214ecd30b81a95a46522ef67bf5420103e7dca5df1c85e85960b9e7459d88"
  license "Apache-2.0"
  head "https://github.com/apple/swift-protobuf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "21b4f555735d3dda7cedd73120378da029fdeaa3b6d42f80f44b6bd46629afcb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e90ac20936aa5c6cd98fbc3ca6af1c377dd37cd5fa6d01a18ad6dd52cb2ba6a4"
    sha256 cellar: :any_skip_relocation, monterey:       "fdf6d90e34b10136bbfd402b175fff9bf63471fca5e6f875c801bb48a5696852"
    sha256 cellar: :any_skip_relocation, big_sur:        "0f68757a3369c250360d927f4847fb06852ea4a862862adabe5486f63549ae14"
    sha256 cellar: :any_skip_relocation, catalina:       "1be7bc0f3f19f78c0ad7897d75847ff206ecb976c9de6fae23872451cc69e87a"
    sha256                               x86_64_linux:   "7e7d5e63949d186fd175c05edc9bb92ac56ae84a175ffbb26c44a084c169af55"
  end

  depends_on xcode: ["8.3", :build]
  depends_on "protobuf"

  uses_from_macos "swift"

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

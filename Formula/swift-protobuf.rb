class SwiftProtobuf < Formula
  desc "Plugin and runtime library for using protobuf with Swift"
  homepage "https://github.com/apple/swift-protobuf"
  url "https://github.com/apple/swift-protobuf/archive/1.20.2.tar.gz"
  sha256 "3fb50bd4d293337f202d917b6ada22f9548a0a0aed9d9a4d791e6fbd8a246ebb"
  license "Apache-2.0"
  head "https://github.com/apple/swift-protobuf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36e84496c7f16bf9f318f899fa2ed3423ca4a302450d1e68d476a03d175099f2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b790680a423626fe077f0f8bc8d24601a07edec2947a4343ff0586493dd1e661"
    sha256 cellar: :any_skip_relocation, monterey:       "362254db2dfe04119a6d32d1a80e22633af98f36fe1d5184afd3a38ac15e7bcc"
    sha256 cellar: :any_skip_relocation, big_sur:        "37265f340278ef0cb6f9ee90f2dfd4f74e6e6f4caa0f16950c50330fb376759a"
    sha256 cellar: :any_skip_relocation, catalina:       "34c6d2be247e52e95a0add0bc40346332b31f666819be89c6a3d269422614eef"
    sha256                               x86_64_linux:   "5d48da7672dfa9401ad037cc5a3b4bbe4434b830c33d0ec7ceadb91c63f0ffff"
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

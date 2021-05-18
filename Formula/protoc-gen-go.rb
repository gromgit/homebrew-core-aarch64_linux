class ProtocGenGo < Formula
  desc "Go support for Google's protocol buffers"
  homepage "https://github.com/golang/protobuf"
  url "https://github.com/golang/protobuf/archive/v1.5.2.tar.gz"
  sha256 "088cc0f3ba18fb8f9d00319568ff0af5a06d8925a6e6cb983bb837b4efb703b3"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/golang/protobuf.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a8ae4e8a4e7760bf13b8369b601d42357b094e61d87020a2164c985092778d0c"
    sha256 cellar: :any_skip_relocation, big_sur:       "ce4def651b09a4f6792bf1154eb821d30320d904e51190ebbb188144161d9da0"
    sha256 cellar: :any_skip_relocation, catalina:      "ce4def651b09a4f6792bf1154eb821d30320d904e51190ebbb188144161d9da0"
    sha256 cellar: :any_skip_relocation, mojave:        "ce4def651b09a4f6792bf1154eb821d30320d904e51190ebbb188144161d9da0"
  end

  depends_on "go" => :build
  depends_on "protobuf"

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w", "./protoc-gen-go"
    prefix.install_metafiles
  end

  test do
    protofile = testpath/"proto3.proto"
    protofile.write <<~EOS
      syntax = "proto3";
      package proto3;
      option go_package = "package/test";
      message Request {
        string name = 1;
        repeated int64 key = 2;
      }
    EOS
    system "protoc", "--go_out=.", "--go_opt=paths=source_relative", "proto3.proto"
    assert_predicate testpath/"proto3.pb.go", :exist?
    refute_predicate (testpath/"proto3.pb.go").size, :zero?
  end
end

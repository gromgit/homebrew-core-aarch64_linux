class Grpcurl < Formula
  desc "Like cURL, but for gRPC"
  homepage "https://github.com/fullstorydev/grpcurl"
  url "https://github.com/fullstorydev/grpcurl/archive/v1.8.6.tar.gz"
  sha256 "18b457f644baabeef0de350596dd8d23563586ee94a3ed3cb290063e097ab934"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/grpcurl"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "8f43abd656201a550bcaf1b5c846acf0241bac90ab773a48bbf57eb32daa1dc0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/grpcurl"
  end

  test do
    (testpath/"test.proto").write <<~EOS
      syntax = "proto3";
      package test;
      message HelloWorld {
        string hello_world = 1;
      }
    EOS
    system "#{bin}/grpcurl", "-msg-template", "-proto", "test.proto", "describe", "test.HelloWorld"
  end
end

class Grpcurl < Formula
  desc "Like cURL, but for gRPC"
  homepage "https://github.com/fullstorydev/grpcurl"
  url "https://github.com/fullstorydev/grpcurl/archive/v1.8.0.tar.gz"
  sha256 "3688ef37e8d821d6a89c68856d9ae68527e7a65b9c64ae380b37b37f1cdeff22"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "d536025d13aa328655941661eca540fbf8280f0ebd0a0efe9945990737db0bf4" => :big_sur
    sha256 "bea72896ce36179bf52695c06aafee5ad29087391c3c7a5162246a901384f5e5" => :arm64_big_sur
    sha256 "b141489fbe726a3f534d86a0f53af867a7b4bff1a92c1c8305e73d5e0fb6f87a" => :catalina
    sha256 "99121cc3d5c1b521dc69511609d1214b4c297a136902e08384161418ceb320dd" => :mojave
    sha256 "c62f76f233dfa5686d3018b351436d469ce142c5714cbe67960478c2a5e4f640" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-X main.version=#{version}", "./cmd/grpcurl"
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

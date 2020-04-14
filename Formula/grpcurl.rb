class Grpcurl < Formula
  desc "Like cURL, but for gRPC"
  homepage "https://github.com/fullstorydev/grpcurl"
  url "https://github.com/fullstorydev/grpcurl/archive/v1.5.1.tar.gz"
  sha256 "0e046500122cb533f9565574a5b06fb74f5c97fe01c93b7550edd5e2edc953ce"

  bottle do
    cellar :any_skip_relocation
    sha256 "02701a390faec176c577065ac1d1159be736fa494ab1bbc9794ffc956341d69a" => :catalina
    sha256 "313a3903efc652677c0707bf8fef59e6b83a02a9fbfcc80d30af928e00e4e3b5" => :mojave
    sha256 "1e5dac2b273abb7c98647325d6232a2b426c9aa71613a3ef89719a02fed6b8f8" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = HOMEBREW_CACHE/"go_cache"
    (buildpath/"src/github.com/fullstorydev/grpcurl").install buildpath.children
    cd "src/github.com/fullstorydev/grpcurl/cmd" do
      system "go", "build", "-ldflags", "-X main.version=#{version}",
             "-o", bin/"grpcurl", "./..."
      prefix.install_metafiles
    end
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

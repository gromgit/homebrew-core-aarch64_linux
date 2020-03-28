class Xmake < Formula
  desc "Cross-platform build utility based on Lua"
  homepage "https://xmake.io/"
  url "https://github.com/xmake-io/xmake/releases/download/v2.3.2/xmake-v2.3.2.tar.gz"
  sha256 "b189074320ce1b215f85f8f20142fe173d981eb17c2c157f0fa6756fc00dac4e"
  head "https://github.com/xmake-io/xmake.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a12437737aba64b40409f345ac309fe09f209702b15248fa3cd372f86836f806" => :catalina
    sha256 "b787d43f1ff93493c4235ebf2aaa09c4f564661c4b0381ccde001867d4b75870" => :mojave
    sha256 "50fe8f9745ba10b7aeaf6cf642eb81c826361e24aa6293d6bc3da3b4d0eee4f9" => :high_sierra
  end

  def install
    system "make", "build"
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system bin/"xmake", "create", "test"
    cd "test" do
      system bin/"xmake"
      assert_equal "hello world!", shell_output("#{bin}/xmake run").chomp
    end
  end
end

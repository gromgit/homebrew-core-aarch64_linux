class CfTool < Formula
  desc "Command-line tool for Codeforces contests"
  homepage "https://github.com/xalanq/cf-tool"
  url "https://github.com/xalanq/cf-tool/archive/v0.8.2.tar.gz"
  sha256 "04eeb0ebfd2f15f81940012def95ec964498f7053029aa8b192d99c5a88bb98b"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/xalanq/cf-tool").install buildpath.children
    cd "src/github.com/xalanq/cf-tool" do
      system "go", "build", "-o", "cf", "-trimpath", "-ldflags", "-s -w", "cf.go"
      bin.install "cf"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/cf", "list", "1256"
  end
end

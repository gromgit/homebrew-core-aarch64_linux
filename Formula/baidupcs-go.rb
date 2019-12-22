class BaidupcsGo < Formula
  desc "The terminal utility for Baidu Network Disk"
  homepage "https://github.com/iikira/BaiduPCS-Go"
  url "https://github.com/iikira/BaiduPCS-Go/archive/v3.6.1.tar.gz"
  sha256 "07e1d802e6b49425a53b883c354d8b753de55f7005ac8c7b27cd8396db0447da"

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"baidupcs-go"
  end

  test do
    system bin/"baidupcs-go", "run", "touch", "test.txt"
    assert_predicate testpath/"test.txt", :exist?
  end
end

class Nift < Formula
  desc "Cross-platform open source framework for managing and generating websites"
  homepage "https://nift.cc/"
  url "https://github.com/nifty-site-manager/nsm/archive/v2.2.tar.gz"
  sha256 "65d0d597aa0de5683a63e3f0524e1aa5d99e081aeb3124624c612e55b49c54be"

  bottle do
    cellar :any_skip_relocation
    sha256 "ff5e142463871e62a8321d98ce8a775bae35531cb391016829a666ee8e2fe5fa" => :catalina
    sha256 "dd1d722e05ed3f257aedc3efab34f17415bc2b31da3cfd6fd244884df57d7ced" => :mojave
    sha256 "212b325f8b6e1d24b4e40b05c3a07c54f5aa0ed288da2b8fe502f269cbbed826" => :high_sierra
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    mkdir "empty" do
      system "#{bin}/nsm", "init", ".html"
      assert_predicate testpath/"empty/output/index.html", :exist?
    end
  end
end

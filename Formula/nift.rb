class Nift < Formula
  desc "Cross-platform open source framework for managing and generating websites"
  homepage "https://nift.cc/"
  url "https://github.com/nifty-site-manager/nsm/archive/v2.3.7.tar.gz"
  sha256 "b624eeb76c1b171670973bd94bb8a62484e76124fdc3f36a8e71938e182ff244"

  bottle do
    cellar :any_skip_relocation
    sha256 "6ba456a4cc04bfa8bfce07394d18d680f1cdb0f36e81bfdf264eeb3c68f95f98" => :catalina
    sha256 "50d9b27d887301626a680f438a0a7aba625fe59e9d8a4dceb035172e5b209430" => :mojave
    sha256 "8cbc1db254391eeedc7d1a5c83953215c30fb0ad5c7d1bbb27157009ab9a8a69" => :high_sierra
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

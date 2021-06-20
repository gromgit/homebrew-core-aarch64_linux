class Ccextractor < Formula
  desc "Free, GPL licensed closed caption tool"
  homepage "https://www.ccextractor.org/"
  url "https://github.com/CCExtractor/ccextractor/archive/v0.89.tar.gz"
  sha256 "bbe8d95347d0cf31bd26489b733fd959a7b98c681f14c59309bff54713fd539d"
  license "GPL-2.0"
  head "https://github.com/ccextractor/ccextractor.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "85a8a4d0137ec1f12e98ad39156d1ee95874b037d432c9620d65f695dcbb3daa"
    sha256 cellar: :any_skip_relocation, catalina: "22e12e434b2a59c0ee63db41e876add7ab686d7e015c7319bf3cecd01ae2de1e"
    sha256 cellar: :any_skip_relocation, mojave:   "f389af83990016793f29329e7de8ca7d58c09a25c7faff62bc61d0100d9ee425"
  end

  def install
    cd "mac" do
      system "./build.command"
      bin.install "ccextractor"
    end
    (pkgshare/"examples").install "docs/ccextractor.cnf.sample"
  end

  test do
    touch testpath/"test"
    pid = fork do
      exec bin/"ccextractor", testpath/"test"
    end
    Process.wait(pid)
    assert_predicate testpath/"test.srt", :exist?
  end
end

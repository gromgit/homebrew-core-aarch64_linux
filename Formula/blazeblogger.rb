class Blazeblogger < Formula
  desc "CMS for the command-line"
  homepage "http://blaze.blackened.cz/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/blazeblogger/blazeblogger-1.2.0.tar.gz"
  sha256 "39024b70708be6073e8aeb3943eb3b73d441fbb7b8113e145c0cf7540c4921aa"
  license "GPL-3.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/blazeblogger"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "95b91a60db03ed0ed29054d209ebb03feacd86f1aa9cbf383ca1f9f7d13f25fd"
  end

  def install
    # https://code.google.com/p/blazeblogger/issues/detail?id=51
    ENV.deparallelize
    system "make", "prefix=#{prefix}", "compdir=#{prefix}", "install"
  end

  test do
    system bin/"blaze", "init"
    system bin/"blaze", "config", "blog.title", "Homebrew!"
    system bin/"blaze", "make"
    assert_predicate testpath/"default.css", :exist?
    assert_match "Homebrew!", File.read(".blaze/config")
  end
end

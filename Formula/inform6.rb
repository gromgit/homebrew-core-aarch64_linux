class Inform6 < Formula
  desc "Design system for interactive fiction"
  homepage "https://inform-fiction.org/inform6.html"
  url "https://ifarchive.org/if-archive/infocom/compilers/inform6/source/inform-6.34-6.12.4-1.tar.gz"
  version "6.34-6.12.4-1"
  sha256 "8cc1983c7bbed7f23fcf3cd549fe8dc10b1a506b95129c35e9f61d2e79b85295"
  license "Artistic-2.0"
  head "https://gitlab.com/DavidGriffith/inform6unix.git"

  bottle do
    sha256 cellar: :any_skip_relocation, catalina:    "961725b635b0a0bec6c5ee2de80485cc2ae54c6704692095bf73afb45d4934a0"
    sha256 cellar: :any_skip_relocation, mojave:      "be06ad010ef37eb03a5ec804cd6547087772350ccc1c03d6854cd4bebd8a5b9d"
    sha256 cellar: :any_skip_relocation, high_sierra: "087ee415674833ac532a1fe70c30d8d84015d91e1eeab76273707e7754ef8be4"
  end

  resource "Adventureland.inf" do
    url "https://inform-fiction.org/examples/Adventureland/Adventureland.inf"
    sha256 "3961388ff00b5dfd1ccc1bb0d2a5c01a44af99bdcf763868979fa43ba3393ae7"
  end

  def install
    # Disable parallel build until release with https://gitlab.com/DavidGriffith/inform6unix/-/commit/dab07d5c83a42e1c52e4058d6a31a8137f54b59c
    # ships; see https://gitlab.com/DavidGriffith/inform6unix/-/issues/26
    ENV.deparallelize
    system "make", "PREFIX=#{prefix}", "MAN_PREFIX=#{man}", "install"
  end

  test do
    resource("Adventureland.inf").stage do
      system "#{bin}/inform", "Adventureland.inf"
      assert_predicate Pathname.pwd/"Adventureland.z5", :exist?
    end
  end
end

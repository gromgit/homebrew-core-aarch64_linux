class Janet < Formula
  desc "Dynamic language and bytecode vm"
  homepage "https://janet-lang.org"
  url "https://github.com/janet-lang/janet/archive/v1.22.0.tar.gz"
  sha256 "7c6969f8e82badc7afa28aa1054555c1c91d2858f9f45c41a82557f5c5ce85bd"
  license "MIT"
  head "https://github.com/janet-lang/janet.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "3b33f8539400e99c0dd6d59a880cfa3407413a0a5e1a68484b05ff5d89b17489"
    sha256 cellar: :any,                 arm64_big_sur:  "745fb723c62b2f69e72855daac695a5c30f5c6b1f5700bd4d8079b8471ab87f0"
    sha256 cellar: :any,                 monterey:       "50e2b8262dc7a0168ddfe9208e84c072a5601e989ca090499af6a058013df807"
    sha256 cellar: :any,                 big_sur:        "681641cf43f1b8611cf6ccd1fd44e77b8f0f250ee6d166c18b4b9993315f7d40"
    sha256 cellar: :any,                 catalina:       "0c81821621a4fb46c723ec22571261eaa855ec7dc9fe4d7a3dc007239842345f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da24ddcae5dbd7ed69cd1394255e8b00de25177578ebe8f9e66d243781496461"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  resource "jpm" do
    url "https://github.com/janet-lang/jpm/archive/refs/tags/v1.0.0.tar.gz"
    sha256 "858d4ef2f6ac78222c53154dd91f8fb5994e3c3cbe253c9b0d3b9d52557eeb9b"
  end

  def install
    system "meson", "setup", "build", *std_meson_args
    cd "build" do
      system "ninja"
      system "ninja", "install"
    end
    ENV["PREFIX"] = prefix
    resource("jpm").stage do
      system bin/"janet", "bootstrap.janet"
    end
  end

  test do
    assert_equal "12", shell_output("#{bin}/janet -e '(print (+ 5 7))'").strip
    assert_predicate HOMEBREW_PREFIX/"bin/jpm", :exist?, "jpm must exist"
    assert_predicate HOMEBREW_PREFIX/"bin/jpm", :executable?, "jpm must be executable"
    assert_match prefix.to_s, shell_output("#{bin}/jpm show-paths")
  end
end

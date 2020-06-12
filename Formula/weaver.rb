class Weaver < Formula
  desc "Command-line tool for Weaver"
  homepage "https://github.com/scribd/Weaver"
  url "https://github.com/scribd/Weaver/archive/1.0.6.tar.gz"
  sha256 "6efdf6572a7c20f923a5d3a04855877935f5a3843c251bb98d44876cbdcb58ee"

  bottle do
    cellar :any_skip_relocation
    sha256 "f50eb3311114cf71d1371c4f627e1c741b7880241f452e9bc89e461ec41128c3" => :catalina
    sha256 "8ad60fc4a1d4bfdb6095c14ff5cfd6cccf186d424b3038d2279ac921d3aa52ac" => :mojave
  end

  depends_on :xcode => ["11.2", :build]

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    # Weaver uses Sourcekitten and thus, has the same sandbox issues.
    # Rewrite test after sandbox issues investigated.
    # https://github.com/Homebrew/homebrew/pull/50211
    system "#{bin}/weaver", "version"
  end
end

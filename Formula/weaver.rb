class Weaver < Formula
  desc "Command-line tool for Weaver"
  homepage "https://github.com/scribd/Weaver"
  url "https://github.com/scribd/Weaver/archive/1.0.4.tar.gz"
  sha256 "65c15b0575775b0cc5205f1bf4ebcbf471fc3f048a462e06dca13b93138269fc"

  bottle do
    cellar :any_skip_relocation
    sha256 "a3db270b15db691cdbd6b84e512daed3dbc722bef27a87da61e65891bea20563" => :catalina
    sha256 "d6e02b0df46f0ccbcf131a1f1d1b9a8d641b9602462824cc9a8d3c856bf3ba60" => :mojave
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

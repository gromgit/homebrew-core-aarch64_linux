class Term < Formula
  desc "Open terminal in specified directory (and optionally run command)"
  homepage "https://github.com/liyanage/macosx-shell-scripts/blob/HEAD/term"
  url "https://raw.githubusercontent.com/liyanage/macosx-shell-scripts/e29f7eaa1eb13d78056dec85dc517626ab1d93e3/term"
  version "2.1"
  sha256 "a0a430f024ff330c6225fe52e3ed9278fccf8a9cd2be9023282481dacfdffb3c"

  livecheck do
    skip "Cannot reliably check for new releases upstream"
  end

  depends_on :macos

  def install
    bin.install "term"
  end
end

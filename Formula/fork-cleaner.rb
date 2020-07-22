class ForkCleaner < Formula
  desc "Cleans up old and inactive forks on your GitHub account"
  homepage "https://github.com/caarlos0/fork-cleaner"
  url "https://github.com/caarlos0/fork-cleaner/archive/v1.7.0.tar.gz"
  sha256 "f95140760f79e33456372161a402b7b94d6309f8b69d21fc6430289bab340b5f"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "3764b433f450ce49be8d8e002c5ec457fd75850a300b9e0868ced294b78fca42" => :catalina
    sha256 "6f1cd16063670084e17628102f5dced6d0d4fb15d2a8ae80c00e531a35377135" => :mojave
    sha256 "51d4939c1f7139ecf9eee2783ca15a5e40142fbeee8f85b426c96e9fc424df03" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "make"
    bin.install "fork-cleaner"
    prefix.install_metafiles
  end

  test do
    output = shell_output("#{bin}/fork-cleaner 2>&1", 1)
    assert_match "missing github token", output
  end
end

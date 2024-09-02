class Unifdef < Formula
  desc "Selectively process conditional C preprocessor directives"
  homepage "https://dotat.at/prog/unifdef/"
  url "https://dotat.at/prog/unifdef/unifdef-2.12.tar.gz"
  sha256 "fba564a24db7b97ebe9329713ac970627b902e5e9e8b14e19e024eb6e278d10b"
  license all_of: [
    "BSD-2-Clause",
    "BSD-3-Clause", # only for `unifdef.1`
  ]
  head "https://github.com/fanf2/unifdef.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/unifdef"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "4269389c0f35ca7a2fb15613328ebd2a0ed7611cd85c453828d95c19bdff460c"
  end

  keg_only :provided_by_macos

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    pipe_output("#{bin}/unifdef", "echo ''")
  end
end

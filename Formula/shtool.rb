class Shtool < Formula
  desc "GNU's portable shell tool"
  homepage "https://www.gnu.org/software/shtool/"
  url "https://ftp.gnu.org/gnu/shtool/shtool-2.0.8.tar.gz"
  mirror "https://ftpmirror.gnu.org/shtool/shtool-2.0.8.tar.gz"
  sha256 "1298a549416d12af239e9f4e787e6e6509210afb49d5cf28eb6ec4015046ae19"
  license "GPL-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/shtool"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "d6e78154700e47c9185eba9d68ea7123d9a242730f8663da5b917ec2fef38cfa"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "Hello World!", pipe_output("#{bin}/shtool echo 'Hello World!'").chomp
  end
end

class Oksh < Formula
  desc "Portable OpenBSD ksh, based on the public domain Korn shell (pdksh)"
  homepage "https://github.com/ibara/oksh"
  url "https://github.com/ibara/oksh/releases/download/oksh-7.1/oksh-7.1.tar.gz"
  sha256 "9dc0b0578d9d64d10c834f9757ca11f526b562bc5454da64b2cb270122f52064"
  license all_of: [:public_domain, "BSD-3-Clause", "ISC"]
  head "https://github.com/ibara/oksh.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/oksh"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "130e843f6f74eab540adac7b5d4fdffb9e50299d2eab791a47699fbecbf2761b"
  end

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "hello", shell_output("#{bin}/oksh -c \"echo -n hello\"")
  end
end

class SshCopyId < Formula
  desc "Add a public key to a remote machine's authorized_keys file"
  homepage "https://www.openssh.com/"
  url "https://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-8.8p1.tar.gz"
  mirror "https://mirror.vdms.io/pub/OpenBSD/OpenSSH/portable/openssh-8.8p1.tar.gz"
  version "8.8p1"
  sha256 "4590890ea9bb9ace4f71ae331785a3a5823232435161960ed5fc86588f331fe9"
  license "SSH-OpenSSH"
  head "https://github.com/openssh/openssh-portable.git", branch: "master"

  livecheck do
    formula "openssh"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "48219c19e58e8fe2490c94d4a9499ac378c3e0b88f1fe60b153449405382e8e3"
  end

  keg_only :provided_by_macos

  def install
    bin.install "contrib/ssh-copy-id"
    man1.install "contrib/ssh-copy-id.1"
  end

  test do
    output = shell_output("#{bin}/ssh-copy-id -h 2>&1", 1)
    assert_match "identity_file", output
  end
end

class Daemonize < Formula
  desc "Run a command as a UNIX daemon"
  homepage "https://software.clapper.org/daemonize/"
  url "https://github.com/bmc/daemonize/archive/release-1.7.8.tar.gz"
  sha256 "20c4fc9925371d1ddf1b57947f8fb93e2036eb9ccc3b43a1e3678ea8471c4c60"
  license "BSD-3-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/daemonize"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "4a5455f6b76b24bfcca8a89aea979a69a471e26e70db8eacc7bd60737f72fa8c"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    dummy_script_file = testpath/"script.sh"
    output_file = testpath/"outputfile.txt"
    pid_file = testpath/"pidfile.txt"
    dummy_script_file.write <<~EOS
      #!/bin/sh
      echo "#{version}" >> "#{output_file}"
    EOS
    chmod 0700, dummy_script_file
    system "#{sbin}/daemonize", "-p", pid_file, dummy_script_file
    assert_predicate pid_file, :exist?,
      "The file containing the PID of the child process was not created."
    sleep(4) # sleep while waiting for the dummy script to finish
    assert_predicate output_file, :exist?,
      "The file which should have been created by the child process doesn't exist."
    assert_match version.to_s, output_file.read
  end
end

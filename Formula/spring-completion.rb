class SpringCompletion < Formula
  desc "Bash completion for Spring"
  homepage "https://github.com/jacaetevha/spring_bash_completion"
  url "https://github.com/jacaetevha/spring_bash_completion/archive/v0.0.1.tar.gz"
  sha256 "a97b256dbdaca894dfa22bd96a6705ebf4f94fa8206d05f41927f062c3dd60bf"
  license "Unlicense"
  head "https://github.com/jacaetevha/spring_bash_completion.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/spring-completion"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "0577442ada28666dc3b6edcd50c7a95ca696dc6f218cde548f2d11fdcc597eaa"
  end

  def install
    bash_completion.install "spring.bash" => "spring"
  end

  test do
    assert_match "-F _spring",
      shell_output("bash -c 'source #{bash_completion}/spring && complete -p spring'")
  end
end

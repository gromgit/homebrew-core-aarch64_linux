class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.6.7/phpstan.phar"
  sha256 "f03739db5bdf8e64bcdee64c18ced7b14863832512f5cf5d1039567f1a6258a0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e376343ff3878fc5c7b8f8cf677f375972ad8ce2c9b107eb398ca76d6f8e419"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0e376343ff3878fc5c7b8f8cf677f375972ad8ce2c9b107eb398ca76d6f8e419"
    sha256 cellar: :any_skip_relocation, monterey:       "3483de344793de42bdd7f6bd0077c4b3b78ba7a3857ee6905a4d00f8a719a1d3"
    sha256 cellar: :any_skip_relocation, big_sur:        "3483de344793de42bdd7f6bd0077c4b3b78ba7a3857ee6905a4d00f8a719a1d3"
    sha256 cellar: :any_skip_relocation, catalina:       "3483de344793de42bdd7f6bd0077c4b3b78ba7a3857ee6905a4d00f8a719a1d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e376343ff3878fc5c7b8f8cf677f375972ad8ce2c9b107eb398ca76d6f8e419"
  end

  depends_on "php" => :test

  # Keg-relocation breaks the formula when it replaces `/usr/local` with a non-default prefix
  on_macos do
    pour_bottle? only_if: :default_prefix if Hardware::CPU.intel?
  end

  def install
    bin.install "phpstan.phar" => "phpstan"
  end

  test do
    (testpath/"src/autoload.php").write <<~EOS
      <?php
      spl_autoload_register(
          function($class) {
              static $classes = null;
              if ($classes === null) {
                  $classes = array(
                      'email' => '/Email.php'
                  );
              }
              $cn = strtolower($class);
              if (isset($classes[$cn])) {
                  require __DIR__ . $classes[$cn];
              }
          },
          true,
          false
      );
    EOS

    (testpath/"src/Email.php").write <<~EOS
      <?php
        declare(strict_types=1);

        final class Email
        {
            private string $email;

            private function __construct(string $email)
            {
                $this->ensureIsValidEmail($email);

                $this->email = $email;
            }

            public static function fromString(string $email): self
            {
                return new self($email);
            }

            public function __toString(): string
            {
                return $this->email;
            }

            private function ensureIsValidEmail(string $email): void
            {
                if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
                    throw new InvalidArgumentException(
                        sprintf(
                            '"%s" is not a valid email address',
                            $email
                        )
                    );
                }
            }
        }
    EOS
    assert_match(/^\n \[OK\] No errors/,
      shell_output("#{bin}/phpstan analyse --level max --autoload-file src/autoload.php src/Email.php"))
  end
end

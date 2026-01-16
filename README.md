# create-image

[![Tests](https://img.shields.io/github/actions/workflow/status/LinqLover/create-image/test.yml?label=%F0%9F%A7%AA%20Test)](https://github.com/LinqLover/create-image/actions/workflows/test.yml)
[![Lint](https://img.shields.io/github/actions/workflow/status/LinqLover/create-image/lint.yml?label=%F0%9F%A7%B5%20Lint)](https://github.com/LinqLover/create-image/actions/workflows/lint.yml)
[![Public workflows that use this action](https://img.shields.io/endpoint?url=https%3A%2F%2Fused-by.vercel.app%2Fapi%2Fgithub-actions%2Fused-by%3Faction%3DLinqLover%2Fcreate-image%26badge%3Dtrue)](https://github.com/search?q=LinqLover%2Fcreate-image+path%3A%2F%5E%5C.github%5C%2Fworkflows%5C%2F%2F&ref=opensearch&type=code)

> GitHub Action for creating and preparing an all-in-one image for [Squeak](https://squeak.org/).

You can use this action in your workflow to automatically deploy a **one-click/all-in-one image bundle of Squeak** containing **your app or modifications.**
- The bundle is fetched from <https://squeak.org/downloads> and will contain a **ready-to-use image** and **VM binaries** for all supported platforms (head over to [squeak-smalltalk/squeak-app](https://github.com/squeak-smalltalk/squeak-app) for more information).
- You can run **custom scripts** to **prepare** the image before saving it or to **postpare** it when it is opened again.
- You can choose the **Squeak version** and **bitness** of the image.

## Usage

### Example workflow

Below is a simple example workflow that creates an image, loads some code into it, and uploads the image bundle as an artifact of your workflow:

```yml
on:
  push:
    branches: [master]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: LinqLover/create-image@latest
        id: create-image
        with:
          squeak-version: '6.0'
          prepare-script: ./scripts/prepareImage.st
      - uses: actions/upload-artifact@master
        with:
          name: image
          path: ${{ steps.create-image.outputs.bundle-path }}
```

In this example, `scripts/prepareImage.st` might look like this:

```smalltalk
"Install something..."
Installer new merge: #ffi.

"Open some welcome contents..."
MovingEyeMorph extraExampleSqueakIsWatchingYou openCenteredInWorld.
```

### Inputs

<table>
  <thead>
    <tr>
      <td>Parameter</td>
      <td>Description</td>
      <td>Example</td>
      <td>Required?</td>
    </tr>
  <tbody>
    <tr>
      <td><code>squeak-version</code></td>
      <td>The version of Squeak to be used.</td>
      <td><code>trunk</code>, <code>'6.0'</code></td>
      <td><i>required</i></td>
    </tr>
    <tr>
      <td><code>squeak-bitness</code></td>
      <td>The bitness of the image to be created. Defaults to <code>64</code>.</td>
      <td><code>64</code>, <code>32</code> (⚠ currently not supported on GitHub Actions, see <a href="https://github.com/actions/runner/issues/1181">actions/runner#1181</a>)</td>
      <td><i>optional</i></td>
    </tr>
    <tr>
      <td><code>prepare-script</code></td>
      <td>A script to be filed into the image before saving it.</td>
      <td><code>/path/to/script.st</code></td>
      <td><i>optional</i></td>
    </tr>
    <tr>
      <td><code>postpare-script</code></td>
      <td>A script to be executed in the image after saving it, i.e., at the moment the user opens it again.</td>
      <td><code>/path/to/script.st</code></td>
      <td><i>optional</i></td>
    </tr>
  </tbody>
</table>

All the silly mistakes and typos made by you in the prepare/postpare scripts will be caught by the action and displayed in the action log.

### Outputs

<table>
  <thead>
    <tr>
      <td>Parameter</td>
      <td>Description</td>
      <td>Example</td>
    </tr>
  <tbody>
    <tr>
      <td><code>bundle-path</code></td>
      <td>Indicates the path to the created bundle file.</td>
      <td><code>/path/to/Squeak6.0Alpha-12345-64bit-AllInOne.zip</code></td>
    </tr>
  </tbody>
</table>

To browse further usage examples, click [here](https://github.com/search?q=LinqLover%2Fcreate-image+path%3A%2F%5E%5C.github%5C%2Fworkflows%5C%2F%2F&ref=opensearch&type=code).

## Contribution

... is as always very welcome! If you use this action, have any ideas for improvements, or even would like to submit your patch, my issues & PRs are open!

---

Carpe Squeak! 🎈

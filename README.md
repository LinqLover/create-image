# create-image

> GitHub Action for creating and preparing an all-in-one image for [Squeak](https://squeak.org/).

You can use this action in your workflow to automatically deploy a **one-click/all-in-one image bundle of Squeak** containing **your app or modifications.**
- The bundle is fetched from <https://squeak.org/downloads> and will contain a **ready-to-use image** and **VM binaries** for all supported platforms (head over to [squeak-smalltalk/squeak-app](https://github.com/squeak-smalltalk/squeak-app) for more information).
- Currently, **only the latest version** of the Squeak [Trunk](http://source.squeak.org/trunk) is supported.
- Currently, only 64-bit binaries are supported.

## Usage

### Example workflow

Below is a simple example workflow that creates an image, loads some code into it, and uploads the image bundle as a artifact of your workflow:

```yml
on:
  push:
    branches: [master]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: LinqLover/create-image@v1
        id: create-image
        with:
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
      <td><code>prepare-script</code></td>
      <td>A script to be filed into the image before saving it.</td>
      <td><code>/path/to/script.st</code></td>
      <td><i>optional</i></td>
    </tr>
    <tr>
      <td><code>postpare-script</code></td>
      <td>A script to be executed in the after saving it, i.e., in the moment the user opens it again.</td>
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

## Contribution

... is as always very welcome! If you use this action, have any ideas for improvements, or even would like to submit your patch, my issues & PRs are open!

---

Carpe Squeak! 🎈
